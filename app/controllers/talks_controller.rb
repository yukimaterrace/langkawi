class TalksController < ApplicationController
  before_action :set_pager_params, only: :index

  def index
    relation_id = params.require(:relation_id)
    validate_owners(Relation.find(relation_id))

    render :json => pager_response(Talk.where(relation_id: relation_id))
  end

  def create
    talk = params.require(:talk).permit(:relation_id, :message)
    
    r = Relation.find(talk[:relation_id])
    validate_owners(r)

    unless r.status.to_sym == :accepted
      raise ApiErrors::AcceptedStatusError
    end

    render :json => Talk.create(talk.merge({ submitter: resolve_submitter(r), status: :enabled }))
  end

  def update
    id = params.required(:id)
    talk = params.required(:talk).permit(:message, :status)

    t = Talk.find(id)
    validate_owner(t, Relation.find(t.relation_id))
    validate_update_param(t, talk)

    render :json => Talk.update(id, talk)
  end

  private

  def validate_owners(relation)
    unless @user.id == relation.user_from_id || @user.id == relation.user_to_id
      raise ApiErrors::OwnersRequiredError
    end
  end
  
  def validate_owner(talk, relation)
    validated =
      case talk.submitter.to_sym
      when :relation_from then
        @user.id == relation.user_from_id
      else
        @user.id == relation.user_to_id
      end
    unless validated
      raise ApiErrors::OwnerRequiredError
    end
  end

  def validate_update_param(talk, param)
    if talk.status.to_sym == :disabled
      raise ApiErrors::EnabledStatusError
    end

    status = param[:status]&.to_sym
    if status.present?
      unless status == :disabled
        raise ApiErrors::ParamsValidationError, status
      end
    end
  end

  def resolve_submitter(relation)
    @user.id == relation.user_from_id ? :relation_from : :relation_to
  end
end

class TalksController < ApplicationController
  include RelationService

  before_action :set_pager_params, only: [:index, :index_rooms]

  def index
    relation_id = params.require(:relation_id)
    validate_owners(Relation.find(relation_id))

    render :json => pager_response(Talk.where(relation_id: relation_id).order(created_at: :desc))
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

  def index_rooms
    talk_ids = Talk.joins(:relation)
      .merge(Relation.where(user_from_id: @user.id).or(Relation.where(user_to_id: @user.id)))
      .group(:relation_id)
      .select('talks.id as id, max(talks.updated_at) as updated_at')
      .map { |talk| talk.id }

    talks = Talk.where(id: talk_ids, status: :enabled)
      .eager_load(:relation)
      .order(updated_at: :desc)

    resp = pager_response(talks) do |talk|
      { relation: relation_response(talk.relation), last_talk: talk }
    end
    render :json => resp
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

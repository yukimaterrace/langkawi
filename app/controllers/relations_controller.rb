class RelationsController < ApplicationController
  include RelationService

  before_action :set_pager_params, only: :index
  
  def index
    position_status = params.require(:position_status)
    validate_position_status(position_status)

    cond = user_item_condition(position_status)

    resp = pager_response(cond.order(updated_at: :desc)) do |r|
      relation_response(r)
    end
    render :json => resp, include: :detail
  end

  def show
    counter_user_id = params.require(:id)

    relation = find_relation(counter_user_id)

    render_relation_response(relation)
  end

  def create
    user_from_id = @user.id
    user_to_id = params.require(:user_id)
    User.find(user_to_id)

    if user_from_id == user_to_id
      raise ApiErrors::IdenticalUserError
    end

    if Relation.exists?(user_from_id: user_to_id, user_to_id: user_from_id)
      raise ApiErrors::CounterRelationExistError
    end

    relation = Relation.create({
      user_from_id: user_from_id,
      user_to_id: user_to_id,
      status: :pending
    }.merge({ action_date_by_next_status(:pending) => DateTime.current }))

    render_relation_response(relation)
  end

  def update
    counter_user_id = params.require(:id)
    status = params.require(:status)

    relation = find_relation( counter_user_id)
    position_status = position_status(relation)

    validate_update_param(position_status, status)

    relation.status = status
    relation[action_date_by_next_status(status)] = Time.current
    relation.save!

    render_relation_response(relation)
  end

  private

  def validate_update_param(position_status, status)
    validate_position_status(position_status)
    unless permitted_transition_statuses(position_status).include? status.to_sym
      raise ApiErrors::ParamsValidationError, status
    end
  end

  def validate_position_status(position_status)
    unless position_statuses.include? position_status
      raise ApiErrors::ParamsValidationError, position_status
    end
  end

  def render_relation_response(relation)
    render :json => relation_response(relation), include: :detail
  end

  def find_relation(counter_user_id)
    Relation
      .where(user_from_id: @user.id, user_to_id: counter_user_id)
      .or(Relation.where(user_from_id: counter_user_id, user_to_id: @user.id))
      .eager_load(user_from: :detail, user_to: :detail)
      .first!
  end

  def user_item_condition(position_status)
    status, position = position_status.split('_')
    case position.to_sym
    when :me then
      user_to_item_condition(status)
    else
      user_from_item_condition(status)
    end
  end

  def user_from_item_condition(status)
    Relation.where(user_to_id: @user.id, status: status).eager_load(user_from: :detail)
  end 

  def user_to_item_condition(status)
      Relation.where(user_from_id: @user.id, status: status).eager_load(user_to: :detail)
  end

  def action_date_by_next_status(status)
    case status.to_sym
    when :pending then
      :action_a_date
    when :withdraw, :declined, :accepted then
      :action_b_date
    else
      :action_c_date
    end
  end
end

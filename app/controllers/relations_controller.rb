class RelationsController < ApplicationController
  before_action :set_pager_params, only: :index
  
  def index
    position_status = params.require(:position_status)
    validate_position_status(position_status)

    cond, user = user_item_condition(position_status)

    resp = pager_response(cond) do |r|
      { user: user::(r) }.merge(r.extract_id_date)
    end
    render :json => resp
  end

  def create
    user_from_id = @user.id
    user_to_id = params.require(:user_id)
    User.find(user_to_id)

    if user_from_id == user_to_id
      raise ApiErrors::IdenticalUserError
    end

    render :json => Relation.create({
      user_from_id: user_from_id,
      user_to_id: user_to_id,
      status: :pending
    }.merge({ action_date_by_next_status(:pending) => DateTime.current }))
  end

  def update
    counter_user_id = params.require(:id)
    position_status = params.require(:position_status)
    status = params.require(:status)

    validate_update_param(position_status, status)

    relation = relation_by_position_status(position_status, counter_user_id)
    relation.status = status
    relation[action_date_by_next_status(status)] = DateTime.current
    relation.save!

    render :json => relation
  end

  private

  def position_statuses
    statues_with("me").zip(statues_with "you").flatten
  end

  def statues_with(suffix)
    Relation.statuses.map(&:first).map { |s| "#{s}_#{suffix}"}
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
    [
      Relation.where(user_to_id: @user.id, status: status).eager_load(:user_from),
      proc { |r| r.user_from }
    ]
  end 

  def user_to_item_condition(status)
    [
      Relation.where(user_from_id: @user.id, status: status).eager_load(:user_to),
      proc { |r| r.user_to }
    ]
  end

  def validate_position_status(position_status)
    unless position_statuses.include? position_status
      raise ApiErrors::ParamsValidationError, position_status
    end
  end

  def validate_update_param(position_status, status)
    validate_position_status(position_status)

    permitted_statuses =
      case position_status.to_sym
      when :pending_me then
        [:withdraw]
      when :pending_you then
        [:accepted, :declined]
      when :withdraw_me then
        [:pending]
      when :accepted_me then
        [:disconnected]
      when :accepted_you then
        [:refused]
      else
        []
      end

    unless permitted_statuses.include? status.to_sym
      raise ApiErrors::ParamsValidationError, status
    end
  end

  def relation_by_position_status(position_status, counter_user_id)
    keys = [:user_from_id, :user_to_id]
    if statues_with("you").include?(position_status)
      keys.reverse!
    end
    Relation.find_by! **(keys.zip([@user.id, counter_user_id]).to_h)
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

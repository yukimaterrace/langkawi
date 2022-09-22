class UsersController < ApplicationController
  include ParamsValidator

  before_action :require_owner, only: :update, unless: proc { @user.admin? }
  before_action :set_pager_params, only: :index

  def initialize
    @resource_sym = :user
    @permitted_keys_for_auth_update = {
      admin: [:first_name, :last_name, :gender, :age, :user_type],
      owner: [:first_name, :last_name, :gender, :age]
    }
  end

  def index
    render :json => pager_response(User.eager_load(:detail).order(updated_at: :desc)), include: :detail
  end

  def show
    id = params.require(:id)
    render :json => User.eager_load(:detail).find(id), include: :detail
  end

  def update
    id = params.require(:id)
    render :json => User.update(id, validated_params_for_auth_update)
  end
end

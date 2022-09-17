class AccountsController < ApplicationController
  skip_before_action :authenticate, only: :create
  before_action :require_admin, except: :create
  before_action :set_pager_params, only: :index

  def initialize
    @include = { :include => :user }
  end

  def index
    render :json => pager_response(Account.eager_load(:user)), **@include
  end

  def create
    account = params.require(:account).permit(:account_type, :email, :password)
    account[:status] = :active

    Account.transaction do
      account = Account.create account
      account.create_user(user_type: :general)
    end

    render :json => account, **@include
  end

  def show
    id = params.require(:id)
    account = Account.eager_load(:user).find(id)
    render :json => account, **@include
  end

  def update
    id = params.require(:id)
    account = params.require(:account).permit(:status)
    render :json => Account.update(id, account), **@include
  end
end

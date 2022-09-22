class LoginController < ApplicationController
  skip_before_action :authenticate, except: :logout

  def login
    email = params.require :email
    password = params.require :password
    account = Account.eager_load(:user).where(email: email, password: password).first!

    uuid = SecureRandom.uuid
    Session.put(uuid, account.user.id)
    render :json => { token: uuid, user_id: account.user.id }
  end

  def logout
    token = token_and_options(request).first
    session.delete token
    success_message
  end
end

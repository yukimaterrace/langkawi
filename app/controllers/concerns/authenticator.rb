# frozen_string_literal: true

module Authenticator
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Token

  def authenticate
    authenticate_with_http_token do |token, _options|
      user_id = Session.get(token)
      @user = user_id && User.find(user_id)
      user_id.present?
    end || (raise ApiErrors::UnauthorizedError)
  end

  def require_admin
    return if @user&.admin?

    raise ApiErrors::AdminRequiredError
  end

  def require_owner
    id = params.require(:id)
    return if @user.id == id.to_i

    raise ApiErrors::OwnerRequiredError
  end
end

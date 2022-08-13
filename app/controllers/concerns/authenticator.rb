module Authenticator
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Token

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      user_id = session[token]
      @user = user_id && User.find(user_id)
      user_id.present?
    end
  end

  def require_admin
    unless @user&.admin?
      raise ApiErrors::AdminRequiredError
    end
  end
end
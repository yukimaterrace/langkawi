module Authenticator
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Token

  def authenticate
    authenticate_with_http_token do |token, options|
      user_id = Session.get(token)
      @user = user_id && User.find(user_id)
      user_id.present?
    end || (raise ApiErrors::UnauthorizedError)
  end

  def require_admin
    unless @user&.admin?
      raise ApiErrors::AdminRequiredError
    end
  end

  def require_owner
    id = params.require(:id)
    unless @user.id == id.to_i
      raise ApiErrors::OwnerRequiredError
    end
  end
end

class ApplicationController < ActionController::API
  include Authenticator
  include ResponseJson
  include Pager
  include ApiErrors

  before_action :authenticate

  rescue_from ApiErrors::BaseError do |error|
    error_json error.error, exception: error.exception
  end
end

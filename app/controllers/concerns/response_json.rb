# frozen_string_literal: true

module ResponseJson
  def success_message
    message 'success'
  end

  def message(message)
    render json: { message: }
  end

  def error_json(error, exception: nil)
    render json: {
      error:,
      exception:
    }, status: error
  end
end

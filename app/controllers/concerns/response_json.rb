module ResponseJson

  def success_message
    message 'success'
  end

  def message(message)
    render :json => { message: message }
  end

  def error_json(status, error, exception: nil)
    render :json => {
      status: status,
      error: error,
      exception: exception
    }, status: status
  end
end
module ResponseJson

  def success_message
    message 'success'
  end

  def message(message)
    render :json => { message: message }
  end

  def error_json(error, exception: nil)
    render :json => {
      error: error,
      exception: exception
    }, status: error
  end
end

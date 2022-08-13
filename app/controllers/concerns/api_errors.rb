module ApiErrors
  class BaseError < StandardError
    attr_reader :status, :error, :exception

    def initialize
      raise NotImplementedError
    end
  end

  class AdminRequiredError < BaseError

    def initialize
      @status = :forbidden
      @error = 'admin required'
      @exception = 'Admin user is required to execute the method.'
    end
  end
end
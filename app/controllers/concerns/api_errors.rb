module ApiErrors
  class BaseError < StandardError
    attr_reader :status, :error, :exception

    def initialize
      raise NotImplementedError
    end
  end

  class UnauthorizedError < BaseError
    
    def initialize
      @status = :unauthorized
      @error = 'ログインが必要です。'
      @exception = 'login is required.'
    end
  end

  class AdminRequiredError < BaseError

    def initialize
      @status = :forbidden
      @error = '管理者権限が必要です。 '
      @exception = 'Admin permission is required.'
    end
  end

  class OwnerRequiredError < BaseError
    
    def initialize
      @status = :forbidden
      @error = '本人であることが必要です。'
      @exception = 'Owner is required.'
    end
  end

  class ParamsValidationError < BaseError

    def initialize(invalid_keys)
      @status = :forbidden
      @error = "不正なキー: #{ invalid_keys }"
      @exception = "invalid keys: #{ invalid_keys }"
    end
  end

  class IdenticalUserError < BaseError
    
    def initialize
      @status = :forbidden
      @error = "同一ユーザーは禁止されています。"
      @exception = "identical user is forbidden"
    end
  end
end

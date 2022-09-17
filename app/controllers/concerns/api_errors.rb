module ApiErrors
  class BaseError < StandardError
    attr_reader :error, :exception

    def initialize
      raise NotImplementedError
    end
  end

  class UnauthorizedError < BaseError
    
    def initialize
      @error = :unauthorized
      @exception = 'ログインが必要です。'
    end
  end

  class AdminRequiredError < BaseError

    def initialize
      @error = :forbidden
      @exception = '管理者権限が必要です。 '
    end
  end

  class OwnerRequiredError < BaseError
    
    def initialize
      @error = :forbidden
      @exception = '本人であることが必要です。'
    end
  end

  class OwnersRequiredError < BaseError
    
    def initialize
      @error = :forbidden
      @exception = '本人たちであることが必要です。'
    end
  end

  class ParamsValidationError < BaseError

    def initialize(invalid_keys)
      @error = :forbidden
      @exception = "不正なキー: #{ invalid_keys }"
    end
  end

  class IdenticalUserError < BaseError
    
    def initialize
      @error =:forbidden
      @exception = "同一ユーザーは禁止されています。"
    end
  end

  class CounterRelationExistError < BaseError
  
    def initialize
      @error =:forbidden
      @exception = "逆の関係が既に存在します。"
    end
  end

  class AcceptedStatusError < BaseError

    def initialize
      @error = :forbidden
      @exception = "交際中であることが必要です。"
    end
  end

  class EnabledStatusError < BaseError

    def initialize
      @error = :forbidden
      @exception = "有効状態であることが必要です。"
    end
  end
end

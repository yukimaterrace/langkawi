# frozen_string_literal: true

module ParamsValidator
  attr_reader :resource_sym, :permitted_keys_for_auth_update, :permitted_keys_for_auth_create

  def validated_params_for_auth_update
    validated_params_for_auth permitted_keys_for_auth_update
  end

  def validated_params_for_auth_create
    validated_params_for_auth permitted_keys_for_auth_create
  end

  private

  def validated_params_for_auth(permitted_keys)
    permitted_keys = permitted_keys[operator_type] || []
    raw_params = params.require(resource_sym)

    invalid_keys = raw_params.keys.map do |key|
      permitted_keys.include?(key.to_sym) ? nil : key.to_sym
    end.compact

    raise ApiErrors::ParamsValidationError, invalid_keys unless invalid_keys.empty?

    raw_params.permit(permitted_keys)
  end

  def operator_type
    id = params[:id]
    if @user.admin?
      :admin
    elsif @user.id == id&.to_i
      :owner
    else
      :others
    end
  end
end

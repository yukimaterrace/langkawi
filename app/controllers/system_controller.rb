# frozen_string_literal: true

class SystemController < ApplicationController
  skip_before_action :authenticate

  def health_check
    success_message
  end
end

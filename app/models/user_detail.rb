# frozen_string_literal: true

class UserDetail < ApplicationRecord
  belongs_to :user

  mount_uploader :picture_a, ImageUploader
  serialize :picture_a, JSON
end

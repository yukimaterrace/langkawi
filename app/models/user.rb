class User < ApplicationRecord
  enum user_type: { admin: 0, general: 1 }
  enum gender: { male: 0, female: 1 }

  belongs_to :account

  validates :user_type, presence: true
end

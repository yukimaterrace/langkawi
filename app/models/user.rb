class User < ApplicationRecord
  enum user_type: { admin: 0, general: 1 }
  enum gender: { male: 0, female: 1 }

  belongs_to :account

  has_one :detail, class_name: 'UserDetail', :foreign_key => 'user_id', dependent: :destroy

  validates :user_type, presence: true
end

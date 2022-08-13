class Account < ApplicationRecord
  enum account_type: { owned: 0,  google: 1, facebook: 2 }
  enum status: { active: 0, deactive: 1, banned: 2 }

  has_one :user, dependent: :destroy

  validates :account_type, :email, :password, :status, presence: true
end

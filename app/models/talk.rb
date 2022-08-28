class Talk < ApplicationRecord
  enum submitter: { relation_from: 0, relation_to: 1 }
  enum status: { enabled: 0, disabled: 1 }

  belongs_to :relation

  validates :relation_id, :submitter, :status, presence: true
end

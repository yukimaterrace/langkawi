class Relation < ApplicationRecord
  # pending 応募済み
  # withdraw 応募取り下げ
  # accepted 承諾済み
  # declined 応募を拒否
  # disconnected 応募した相手との交際停止
  # refused 応募された相手との交際停止
  enum status: { pending: 0, withdraw: 1, accepted: 2, declined: 3, disconnected: 4, refused: 5 }

  # action_a_date pending移行時刻
  # action_b_date withdraw/accepted/declined移行時刻
  # action_c_date declined/disconnected移行時刻
  
  belongs_to :user_from, class_name: 'User', :foreign_key => 'user_from_id'
  belongs_to :user_to, class_name: 'User', :foreign_key => 'user_to_id'

  has_many :talks, dependent: :destroy

  def extract_id_date
    self.slice(:id, :action_a_date, :action_b_date, :action_c_date)
  end
end

class FixSessionExpirationType < ActiveRecord::Migration[7.0]
  def change
    change_column :sessions, :expiration, :datetime
  end
end

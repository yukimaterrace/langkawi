# frozen_string_literal: true

class FixSessionExpirationType < ActiveRecord::Migration[7.0]
  def up
    change_column :sessions, :expiration, :datetime
  end

  def down
    change_column :sessions, :expiration, :date
  end
end

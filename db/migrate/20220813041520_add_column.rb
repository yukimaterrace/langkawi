# frozen_string_literal: true

class AddColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :account_id, :integer
  end
end

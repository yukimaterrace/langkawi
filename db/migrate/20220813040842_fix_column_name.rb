class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :accounts, :type, :account_type
    rename_column :users, :type, :user_type
  end
end

class AddIndexRelations < ActiveRecord::Migration[7.0]
  def change
    add_index :relations, [:user_from_id, :user_to_id], unique: true
  end
end

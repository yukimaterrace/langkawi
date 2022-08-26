class FixRelationColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :relations, :user_a_id, :user_from_id
    rename_column :relations, :user_b_id, :user_to_id
  end
end

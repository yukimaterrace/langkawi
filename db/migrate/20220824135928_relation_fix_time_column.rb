class RelationFixTimeColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :relations, :applied_date, :action_a_date
    add_column :relations, :action_b_date, :datetime
    add_column :relations, :action_c_date, :datetime
  end
end

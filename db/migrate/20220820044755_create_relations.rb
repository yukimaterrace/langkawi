class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.integer :user_a_id
      t.integer :user_b_id
      t.integer :status
      t.datetime :applied_date

      t.timestamps
    end
  end
end

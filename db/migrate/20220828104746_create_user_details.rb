class CreateUserDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :user_details do |t|
      t.integer :user_id
      t.text :description_a
      t.string :picture_a

      t.timestamps
    end
  end
end

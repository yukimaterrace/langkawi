class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :type
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.integer :age

      t.timestamps
    end
  end
end

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.integer :type
      t.string :email
      t.string :password
      t.integer :status

      t.timestamps
    end
    add_index :accounts, :email, unique: true
  end
end

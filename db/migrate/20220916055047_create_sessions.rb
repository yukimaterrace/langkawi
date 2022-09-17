class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.string :uuid
      t.string :user_id
      t.date :expiration

      t.timestamps
    end
  end
end

class CreateTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :talks do |t|
      t.integer :relation_id
      t.text :message
      t.integer :submitter
      t.integer :status

      t.timestamps
    end
  end
end

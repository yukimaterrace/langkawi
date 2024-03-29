# frozen_string_literal: true

class AddIndexRelations < ActiveRecord::Migration[7.0]
  def change
    add_index :relations, %i[user_from_id user_to_id], unique: true
  end
end

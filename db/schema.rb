# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_16_061738) do
  create_table "accounts", force: :cascade do |t|
    t.integer "account_type"
    t.string "email"
    t.string "password"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "relations", force: :cascade do |t|
    t.integer "user_from_id"
    t.integer "user_to_id"
    t.integer "status"
    t.datetime "action_a_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "action_b_date"
    t.datetime "action_c_date"
    t.index ["user_from_id", "user_to_id"], name: "index_relations_on_user_from_id_and_user_to_id", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "uuid"
    t.string "user_id"
    t.datetime "expiration", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "talks", force: :cascade do |t|
    t.integer "relation_id"
    t.text "message"
    t.integer "submitter"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_details", force: :cascade do |t|
    t.integer "user_id"
    t.text "description_a"
    t.string "picture_a"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_type"
    t.string "first_name"
    t.string "last_name"
    t.integer "gender"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
  end

end

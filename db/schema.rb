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

ActiveRecord::Schema[8.1].define(version: 2021_10_25_114542) do
  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.integer "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_accounts_on_bank_id"
    t.index ["name"], name: "index_accounts_on_name"
  end

  create_table "banks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_banks_on_name"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", null: false
    t.datetime "date", precision: nil, null: false
    t.text "description"
    t.text "duplicate_ids"
    t.integer "account_id"
    t.integer "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["bank_id"], name: "index_transactions_on_bank_id"
    t.index ["duplicate_ids"], name: "index_transactions_on_duplicate_ids"
  end

  add_foreign_key "accounts", "banks"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "banks"
end

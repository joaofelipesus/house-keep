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

ActiveRecord::Schema[8.1].define(version: 2026_03_17_223243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", comment: "an optional text with a detailed description"
    t.date "due_date", null: false, comment: "when the bill is charged"
    t.string "payment_method", comment: "An enum with the payment method, e.g. credit card, or pix"
    t.boolean "recurring", comment: "Define if the bill is paid every month"
    t.string "title", null: false, comment: "a simple description"
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2, null: false, comment: "bill value"
    t.index ["title"], name: "index_bills_on_title", unique: true
  end
end

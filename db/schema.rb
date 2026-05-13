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

ActiveRecord::Schema[8.1].define(version: 2026_05_13_200002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", comment: "an optional text with a detailed description"
    t.date "due_date", comment: "when the bill is charged"
    t.string "payment_method", comment: "An enum with the payment method, e.g. credit card, or pix"
    t.integer "recurrent_due_day", comment: "The day where the bill must be paied, it's used only on recurrent bills"
    t.boolean "recurring", comment: "Define if the bill is paid every month"
    t.string "title", null: false, comment: "a simple description"
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2, comment: "bill value"
    t.index ["title"], name: "index_bills_on_title", unique: true
  end

  create_table "invoices", comment: "Invoices related to a bill, is the model that store the act of payment", force: :cascade do |t|
    t.bigint "bill_id", null: false
    t.text "comment", comment: "A optional description of the invoice"
    t.datetime "created_at", null: false
    t.date "due_date", null: false, comment: "The date when the invoice is due"
    t.decimal "payment_amount", precision: 10, scale: 2, comment: "The actual amount paid for the invoice"
    t.date "payment_date", comment: "The date when the bill was paid"
    t.string "payment_status", default: "pending", null: false, comment: "A enum with the payment status of the invoice (pending, paid, delayed)"
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_invoices_on_bill_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "invoices", "bills"
end

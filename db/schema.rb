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

ActiveRecord::Schema[8.0].define(version: 2026_03_05_230000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price_per_m3", precision: 10, scale: 2, null: false
    t.decimal "surcharge_percentage", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "reading_id", null: false
    t.bigint "user_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.text "notes"
    t.datetime "issued_at", null: false
    t.datetime "due_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reading_id"], name: "index_invoices_on_reading_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "meters", force: :cascade do |t|
    t.string "serial_number", null: false
    t.string "location"
    t.bigint "user_id", null: false
    t.bigint "zone_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.index ["latitude", "longitude"], name: "index_meters_on_latitude_and_longitude"
    t.index ["serial_number"], name: "index_meters_on_serial_number", unique: true
    t.index ["user_id"], name: "index_meters_on_user_id"
    t.index ["zone_id"], name: "index_meters_on_zone_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.integer "kind", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "admin_id", null: false
    t.decimal "amount_paid", precision: 10, scale: 2, null: false
    t.datetime "paid_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_payments_on_admin_id"
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "readings", force: :cascade do |t|
    t.bigint "meter_id", null: false
    t.bigint "lecturador_id", null: false
    t.decimal "previous_reading", precision: 10, scale: 2, null: false
    t.decimal "current_reading", precision: 10, scale: 2, null: false
    t.decimal "consumption_m3", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "read_at", null: false
    t.string "category_name", null: false
    t.decimal "price_per_m3", precision: 10, scale: 2, null: false
    t.decimal "non_member_surcharge", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_due", precision: 10, scale: 2, default: "0.0", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lecturador_id"], name: "index_readings_on_lecturador_id"
    t.index ["meter_id", "read_at"], name: "index_readings_on_meter_id_and_read_at"
    t.index ["meter_id"], name: "index_readings_on_meter_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "phone"
    t.string "address"
    t.integer "role", default: 3, null: false
    t.bigint "zone_id"
    t.bigint "category_id"
    t.jsonb "push_subscription", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["category_id"], name: "index_users_on_category_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["zone_id"], name: "index_users_on_zone_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zones_on_name", unique: true
  end

  add_foreign_key "invoices", "readings"
  add_foreign_key "invoices", "users"
  add_foreign_key "meters", "users"
  add_foreign_key "meters", "zones"
  add_foreign_key "notifications", "users"
  add_foreign_key "payments", "invoices"
  add_foreign_key "payments", "users", column: "admin_id"
  add_foreign_key "readings", "meters"
  add_foreign_key "readings", "users", column: "lecturador_id"
  add_foreign_key "users", "categories"
  add_foreign_key "users", "zones"
end

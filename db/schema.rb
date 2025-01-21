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

ActiveRecord::Schema[7.1].define(version: 2025_01_21_192450) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "assignee_id", null: false
    t.bigint "assigned_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_id"], name: "index_assignments_on_assigned_id"
    t.index ["assignee_id"], name: "index_assignments_on_assignee_id"
  end

  create_table "biomarkers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_biomarkers_on_name", unique: true
  end

  create_table "health_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_health_records_on_user_id"
  end

  create_table "lab_tests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "biomarker_id", null: false
    t.decimal "value"
    t.string "unit"
    t.bigint "reference_range_id", null: false
    t.string "recordable_type"
    t.integer "recordable_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pdf_id", null: false
    t.index ["biomarker_id"], name: "index_lab_tests_on_biomarker_id"
    t.index ["pdf_id"], name: "index_lab_tests_on_pdf_id"
    t.index ["reference_range_id"], name: "index_lab_tests_on_reference_range_id"
    t.index ["user_id"], name: "index_lab_tests_on_user_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "measurement_type"
    t.decimal "value"
    t.string "source"
    t.string "recordable_type"
    t.integer "recordable_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.index ["user_id"], name: "index_measurements_on_user_id"
  end

  create_table "pdfs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "scan_method"
    t.string "status", default: "pending"
    t.jsonb "processed_data", default: {}
    t.text "notes"
    t.bigint "health_record_id", null: false
    t.bigint "user_id", null: false
    t.index ["health_record_id"], name: "index_pdfs_on_health_record_id"
    t.index ["processed_data"], name: "index_pdfs_on_processed_data", using: :gin
    t.index ["scan_method"], name: "index_pdfs_on_scan_method"
    t.index ["status"], name: "index_pdfs_on_status"
    t.index ["user_id"], name: "index_pdfs_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reference_ranges", force: :cascade do |t|
    t.bigint "biomarker_id", null: false
    t.decimal "min_value"
    t.decimal "max_value"
    t.string "unit"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["biomarker_id"], name: "index_reference_ranges_on_biomarker_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignments", "users", column: "assigned_id"
  add_foreign_key "assignments", "users", column: "assignee_id"
  add_foreign_key "health_records", "users"
  add_foreign_key "lab_tests", "biomarkers"
  add_foreign_key "lab_tests", "pdfs"
  add_foreign_key "lab_tests", "reference_ranges"
  add_foreign_key "lab_tests", "users"
  add_foreign_key "measurements", "users"
  add_foreign_key "pdfs", "health_records"
  add_foreign_key "pdfs", "users"
  add_foreign_key "reference_ranges", "biomarkers"
end

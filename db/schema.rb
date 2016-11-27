# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161126235906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "token"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_members_on_group_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "notification_contents", force: :cascade do |t|
    t.string   "title"
    t.text     "message_body"
    t.integer  "send_to",      default: [],              array: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "attachment"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.boolean  "expired",                 default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "notification_content_id"
    t.string   "attachment_url"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email",   null: false
    t.string   "uid",                    default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "role",                   default: "Student", null: false
    t.json     "tokens"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.json     "groups",                 default: {}
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  add_foreign_key "members", "groups"
  add_foreign_key "members", "users"
end
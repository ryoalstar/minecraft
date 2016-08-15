# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160808184944) do

  create_table "comments", force: :cascade do |t|
    t.integer "server_id", limit: 4,     default: 0, null: false
    t.string  "ip",        limit: 45
    t.string  "poster",    limit: 45
    t.string  "title",     limit: 60
    t.text    "comment",   limit: 65535
    t.string  "time",      limit: 20
  end

  add_index "comments", ["server_id"], name: "server_id", using: :btree

  create_table "exceptions", force: :cascade do |t|
    t.text   "exception", limit: 65535
    t.text   "route",     limit: 65535
    t.string "time",      limit: 45
  end

  create_table "faq", force: :cascade do |t|
    t.string "question", limit: 100
    t.string "answer",   limit: 350
  end

  create_table "hotservers", force: :cascade do |t|
    t.string "server_id", limit: 45
    t.string "timestamp", limit: 45
  end

  create_table "installations", id: false, force: :cascade do |t|
    t.integer "id",     limit: 4,  null: false
    t.string  "uuid",   limit: 45, null: false
    t.string  "device", limit: 45
    t.string  "ip",     limit: 45
    t.string  "time",   limit: 45
  end

  create_table "push_notifications", id: false, force: :cascade do |t|
    t.integer "id",      limit: 4,   null: false
    t.string  "title",   limit: 45,  null: false
    t.string  "message", limit: 200, null: false
    t.string  "time",    limit: 45,  null: false
  end

  create_table "servers", force: :cascade do |t|
    t.string  "name",         limit: 45,                  null: false
    t.string  "owner",        limit: 45
    t.string  "ip",           limit: 60,    default: "",  null: false
    t.integer "port",         limit: 4,     default: 0
    t.string  "banner",       limit: 45
    t.integer "players",      limit: 4,     default: 0
    t.integer "slots",        limit: 4,     default: 0
    t.text    "description",  limit: 65535
    t.integer "status",       limit: 4,     default: 0
    t.string  "version",      limit: 45,    default: "0"
    t.integer "votes",        limit: 4,     default: 0
    t.string  "last_pinged",  limit: 45,    default: "0"
    t.string  "last_online",  limit: 45,    default: "0", null: false
    t.integer "being_pinged", limit: 4,     default: 0
    t.string  "api_key",      limit: 60
    t.integer "comments",     limit: 4,     default: 0
    t.text    "website",      limit: 65535
    t.string  "short_description",  limit: 60,    default: "0"
  end

  add_index "servers", ["ip"], name: "ip", unique: true, using: :btree
  add_index "servers", ["owner"], name: "owner", using: :btree
  add_index "servers", ["status"], name: "status", using: :btree

  create_table "sessions", primary_key: "session_key", force: :cascade do |t|
    t.string  "initialized_at", limit: 45
    t.string  "last_used",      limit: 45
    t.integer "session_type",   limit: 4
    t.string  "session_uuid",   limit: 45
  end

  add_index "sessions", ["session_type"], name: "session_type", using: :btree
  add_index "sessions", ["session_uuid"], name: "session_uuid_idx", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 45
    t.string   "encrypted_password",     limit: 75
    t.string   "email",                  limit: 45
    t.string   "registration_ip",        limit: 45
    t.string   "created_at",             limit: 45
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email", "id"], name: "email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username", "id"], name: "username", using: :btree

  create_table "verification", primary_key: "token", force: :cascade do |t|
    t.string "email", limit: 45
    t.string "time",  limit: 45
  end

  create_table "votes", force: :cascade do |t|
    t.string  "ip",       limit: 45
    t.string  "username", limit: 45
    t.integer "server",   limit: 4
    t.integer "claimed",  limit: 4,  default: 0
    t.string  "time",     limit: 45
  end

  add_index "votes", ["ip", "time", "server"], name: "vote_index", using: :btree
  add_index "votes", ["server"], name: "server", using: :btree
  add_index "votes", ["username"], name: "username", using: :btree

end

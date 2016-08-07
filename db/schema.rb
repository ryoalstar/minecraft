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

ActiveRecord::Schema.define(version: 0) do

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

end
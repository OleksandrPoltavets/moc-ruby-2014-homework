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

ActiveRecord::Schema.define(version: 20150215225452) do

  create_table "archives", force: :cascade do |t|
    t.date     "request_date"
    t.string   "base_currency"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comments"
    t.integer  "commentable_id"
    t.string   "comentable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string   "currency"
    t.float    "sale_rate_nb"
    t.float    "purchase_rate_nb"
    t.float    "sale_rate"
    t.float    "purchase_rate"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "archive_id"
  end

end

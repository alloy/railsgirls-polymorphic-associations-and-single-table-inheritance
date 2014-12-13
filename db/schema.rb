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

ActiveRecord::Schema.define(version: 20141212205238) do

  create_table "invoices", force: true do |t|
    t.string   "customer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_events", force: true do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "ticket_price"
    t.string   "band"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sport_events", force: true do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "ticket_price"
    t.string   "home_team"
    t.string   "away_team"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

end

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

ActiveRecord::Schema.define(version: 20160315105505) do

  create_table "competitions", force: :cascade do |t|
    t.string  "name"
    t.string  "image"
    t.integer "user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "image"
  end

  create_table "games", force: :cascade do |t|
    t.string  "name"
    t.string  "image"
    t.integer "dsr"
    t.integer "season_id"
    t.integer "tee_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.date    "played_date"
    t.float   "playing_handicap"
    t.string  "format"
    t.integer "score"
    t.integer "points"
    t.integer "user_id"
    t.integer "game_id"
    t.integer "tee_id"
    t.integer "adjusted_gross_score"
    t.float   "differential"
    t.float   "daily_scratch_rating"
  end

  create_table "seasons", force: :cascade do |t|
    t.string  "name"
    t.date    "start_date"
    t.date    "end_date"
    t.string  "image"
    t.integer "competition_id"
  end

  create_table "tees", force: :cascade do |t|
    t.string  "colour"
    t.integer "acr"
    t.integer "slope"
    t.integer "course_id"
    t.integer "par"
  end

  create_table "users", force: :cascade do |t|
    t.string  "name"
    t.string  "email"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "image"
    t.float   "handicap"
    t.integer "competition_id"
    t.string  "password_digest"
  end

end

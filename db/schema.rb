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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110311222348) do

  create_table "bounces", :force => true do |t|
    t.boolean  "active",          :default => true
    t.integer  "user_id",                           :null => false
    t.integer  "twitter_user_id",                   :null => false
    t.datetime "expire_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_users", :force => true do |t|
    t.string   "twitter_id"
    t.string   "username"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_users", ["twitter_id"], :name => "index_twitter_users_on_twitter_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "twitter_username"
    t.string   "twitter_access_token"
    t.string   "twitter_access_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["twitter_username"], :name => "index_users_on_twitter_username", :unique => true

end

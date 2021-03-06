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

ActiveRecord::Schema.define(:version => 20110417232700) do

  create_table "bounces", :force => true do |t|
    t.integer  "follow_id",                            :null => false
    t.boolean  "hide_past_bounces", :default => false
    t.datetime "take_action_at",                       :null => false
    t.datetime "executed_at"
    t.datetime "canceled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.integer  "twitter_user_id",                    :null => false
    t.integer  "active_bounce_id"
    t.boolean  "active",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "twitter_bots", :force => true do |t|
    t.integer  "user_id"
    t.integer  "last_direct_message_id", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_users", :force => true do |t|
    t.integer  "twitter_id",    :null => false
    t.string   "username",      :null => false
    t.string   "name",          :null => false
    t.string   "picture_url",   :null => false
    t.string   "last_tweet"
    t.datetime "last_tweet_at"
    t.integer  "friends_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_users", ["twitter_id"], :name => "index_twitter_users_on_twitter_id", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "twitter_user_id",                           :null => false
    t.string   "twitter_access_token",                      :null => false
    t.string   "twitter_access_token_secret",               :null => false
    t.string   "cookie",                      :limit => 64
    t.integer  "friend_update_progress"
    t.integer  "update_friends_progress"
    t.datetime "updated_friends_at"
    t.datetime "last_login_at",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["cookie"], :name => "index_users_on_cookie"
  add_index "users", ["twitter_user_id"], :name => "index_users_on_twitter_user_id", :unique => true

end

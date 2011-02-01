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

ActiveRecord::Schema.define(:version => 20110201043513) do

  create_table "coupon_analysis_records", :force => true do |t|
    t.integer  "coupon_id",                        :null => false
    t.string   "name",                             :null => false
    t.boolean  "is_current",    :default => false, :null => false
    t.date     "activated_at"
    t.text     "young_views"
    t.text     "young_clicks"
    t.text     "prime_views"
    t.text     "prime_clicks"
    t.text     "middle_views"
    t.text     "middle_clicks"
    t.text     "old_views"
    t.text     "old_clicks"
    t.text     "male_views"
    t.text     "male_clicks"
    t.text     "female_views"
    t.text     "female_clicks"
    t.text     "all_views"
    t.text     "all_clicks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_chart_display_generals", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_customer_rels", :force => true do |t|
    t.integer  "coupon_id",                          :null => false
    t.integer  "customer_id",                        :null => false
    t.integer  "available_count",                    :null => false
    t.boolean  "used",            :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupon_customer_rels", ["coupon_id"], :name => "index_coupon_customer_rels_on_coupon_id"
  add_index "coupon_customer_rels", ["customer_id"], :name => "index_coupon_customer_rels_on_customer_id"

  create_table "coupon_generals", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.date     "start_at"
    t.date     "end_at"
    t.date     "activated_at"
    t.integer  "shop_id"
    t.integer  "available_count"
    t.string   "verification_code"
    t.integer  "viewed_count",        :default => 0
    t.integer  "clicked_count",       :default => 0
    t.boolean  "active",              :default => false
    t.boolean  "young_targeted",      :default => false
    t.boolean  "prime_targeted",      :default => false
    t.boolean  "middle_targeted",     :default => false
    t.boolean  "old_targeted",        :default => false
    t.boolean  "all_age_targeted",    :default => true
    t.boolean  "male_targeted",       :default => false
    t.boolean  "female_targeted",     :default => false
    t.boolean  "all_gender_targeted", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "coupons", ["shop_id"], :name => "index_coupons_on_shop_id"

  create_table "customers", :force => true do |t|
    t.string   "email",                                :null => false
    t.boolean  "active",            :default => false, :null => false
    t.boolean  "receive_notice",    :default => true,  :null => false
    t.date     "birthday"
    t.integer  "age"
    t.integer  "gender_id"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
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
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "fine_prints", :force => true do |t|
    t.integer  "coupon_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fine_prints", ["coupon_id"], :name => "index_fine_prints_on_coupon_id"

  create_table "genders", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "masters", :force => true do |t|
    t.string   "email",                                :null => false
    t.boolean  "admin",             :default => false, :null => false
    t.boolean  "active",            :default => false, :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_hours", :force => true do |t|
    t.integer  "shop_id"
    t.string   "content"
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

  create_table "shop_chart_display_generals", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shop_customer_rels", :force => true do |t|
    t.integer  "shop_id",     :null => false
    t.integer  "customer_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shop_customer_rels", ["customer_id"], :name => "index_shop_customer_rels_on_customer_id"
  add_index "shop_customer_rels", ["shop_id"], :name => "index_shop_customer_rels_on_shop_id"

  create_table "shop_generals", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "description",        :null => false
    t.string   "address",            :null => false
    t.string   "postcode",           :null => false
    t.string   "nearest_station",    :null => false
    t.string   "phone_part_1",       :null => false
    t.string   "phone_part_2",       :null => false
    t.string   "phone_part_3",       :null => false
    t.string   "holiday",            :null => false
    t.integer  "master_id",          :null => false
    t.date     "young_start_at"
    t.date     "prime_start_at"
    t.date     "middle_start_at"
    t.date     "old_start_at"
    t.date     "male_start_at"
    t.date     "female_start_at"
    t.date     "all_start_at"
    t.integer  "young_total_count"
    t.integer  "prime_total_count"
    t.integer  "middle_total_count"
    t.integer  "old_total_count"
    t.integer  "male_total_count"
    t.integer  "female_total_count"
    t.integer  "all_total_count"
    t.text     "young_followers"
    t.text     "prime_followers"
    t.text     "middle_followers"
    t.text     "old_followers"
    t.text     "male_followers"
    t.text     "female_followers"
    t.text     "all_followers"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

end

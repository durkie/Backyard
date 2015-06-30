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

ActiveRecord::Schema.define(version: 20150630165657) do

  create_table "components", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "use_count"
    t.string   "global"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "setup"
    t.string   "loop"
    t.string   "testride"
    t.integer  "period"
    t.string   "pretty_name"
    t.string   "description"
  end

  create_table "manifests", force: :cascade do |t|
    t.integer  "sketch_id"
    t.integer  "component_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "manifests", ["component_id"], name: "index_manifests_on_component_id"
  add_index "manifests", ["sketch_id"], name: "index_manifests_on_sketch_id"

  create_table "nunchucks", force: :cascade do |t|
    t.integer  "x_min",        default: 0
    t.integer  "x_max",        default: 255
    t.integer  "x_zero",       default: 124
    t.integer  "y_min",        default: 0
    t.integer  "y_max",        default: 255
    t.integer  "y_zero",       default: 124
    t.integer  "x_accel_min",  default: 0
    t.integer  "x_accel_max",  default: 255
    t.integer  "x_accel_zero", default: 510
    t.integer  "y_accel_min",  default: 0
    t.integer  "y_accel_max",  default: 255
    t.integer  "y_accel_zero", default: 490
    t.integer  "z_accel_min",  default: 0
    t.integer  "z_accel_max",  default: 255
    t.integer  "z_accel_zero", default: 460
    t.integer  "radius",       default: 210
    t.integer  "pitch_min",    default: 0
    t.integer  "pitch_max",    default: 255
    t.integer  "roll_min",     default: 0
    t.integer  "roll_max",     default: 255
    t.string   "name",         default: "Nunchuck"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
  end

  add_index "nunchucks", ["user_id"], name: "index_nunchucks_on_user_id"

  create_table "options", force: :cascade do |t|
    t.integer  "sketch_id"
    t.integer  "component_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "component_name"
    t.text     "kv"
  end

  add_index "options", ["component_id"], name: "index_options_on_component_id"
  add_index "options", ["sketch_id"], name: "index_options_on_sketch_id"

  create_table "pattern_options", force: :cascade do |t|
    t.string   "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patterns", force: :cascade do |t|
    t.string   "global"
    t.string   "setup"
    t.string   "loop"
    t.integer  "motor0"
    t.integer  "motor1"
    t.integer  "motor2"
    t.integer  "on"
    t.integer  "off"
    t.integer  "time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "sketch_id"
    t.integer  "component_id"
  end

  add_index "patterns", ["component_id"], name: "index_patterns_on_component_id"
  add_index "patterns", ["sketch_id"], name: "index_patterns_on_sketch_id"

  create_table "sketch_histories", force: :cascade do |t|
    t.integer  "toy_id"
    t.integer  "sketch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sketch_histories", ["sketch_id"], name: "index_sketch_histories_on_sketch_id"
  add_index "sketch_histories", ["toy_id"], name: "index_sketch_histories_on_toy_id"

  create_table "sketches", force: :cascade do |t|
    t.integer  "size"
    t.string   "build_dir"
    t.string   "sha256"
    t.integer  "num_users"
    t.integer  "total_uses"
    t.string   "config"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "model"
    t.boolean  "hid",              default: false
    t.boolean  "serial_console",   default: true
    t.string   "startup_sequence"
    t.string   "click"
    t.string   "doubleclick"
    t.string   "longpressstart"
    t.float    "time_scale"
    t.float    "power_scale"
  end

  create_table "threshold_functions", force: :cascade do |t|
    t.string   "source"
    t.float    "step_size"
    t.integer  "base_thresh_low"
    t.integer  "base_thresh_high"
    t.integer  "thresh"
    t.string   "source_function"
    t.string   "increase"
    t.boolean  "c_needed"
    t.string   "increase_with_c"
    t.boolean  "z_needed"
    t.string   "increase_with_z"
    t.string   "decrease"
    t.string   "decrease_with_c"
    t.string   "decrease_with_z"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "nunchuck_id"
  end

  add_index "threshold_functions", ["nunchuck_id"], name: "index_threshold_functions_on_nunchuck_id"

  create_table "toys", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sketch_id"
    t.string   "color"
    t.string   "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "nickname"
  end

  add_index "toys", ["sketch_id"], name: "index_toys_on_sketch_id"
  add_index "toys", ["user_id"], name: "index_toys_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "avatar"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end

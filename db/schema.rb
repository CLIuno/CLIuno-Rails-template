# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_12_180823) do
  create_table "blacklisted_tokens", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "invalidated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_blacklisted_tokens_on_token", unique: true
  end

  create_table "comments", id: :string, force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.string "post_id", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "follower_id", null: false
    t.string "following_id", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "following_id"], name: "index_follows_on_follower_id_and_following_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
    t.index ["following_id"], name: "index_follows_on_following_id"
  end

  create_table "posts", id: :string, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "image_url"
    t.boolean "is_paid", default: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roles", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "todos", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_completed", default: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.datetime "deleted_at"
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "gender"
    t.boolean "is_deleted", default: false
    t.boolean "is_online", default: false
    t.boolean "is_otp_enabled", default: false
    t.boolean "is_verified", default: false
    t.string "last_name", null: false
    t.string "nationality"
    t.string "otp_secret"
    t.string "password_digest", null: false
    t.string "phone"
    t.string "refresh_token"
    t.string "reset_password_token"
    t.string "role_id"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "verify_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "posts", on_delete: :cascade
  add_foreign_key "comments", "users"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "follows", "users", column: "following_id"
  add_foreign_key "posts", "users"
  add_foreign_key "todos", "users"
  add_foreign_key "users", "roles"
end

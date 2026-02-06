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

ActiveRecord::Schema[7.2].define(version: 2026_02_06_123000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_emails", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "email", null: false
    t.boolean "primary", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_emails_on_account_id"
    t.index ["email"], name: "index_account_emails_on_email", unique: true
  end

  create_table "accounts", force: :cascade do |t|
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "display_name"
    t.text "bio"
    t.text "description"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["status"], name: "index_accounts_on_status"
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comment_reactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_comment_reactions_on_account_id"
    t.index ["comment_id"], name: "index_comment_reactions_on_comment_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "post_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_comments_on_account_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "credentials", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_credentials_on_account_id", unique: true
  end

  create_table "media_assets", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "asset_type", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "position"], name: "index_media_assets_on_post_id_and_position"
    t.index ["post_id"], name: "index_media_assets_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_posts_on_account_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "username", null: false
    t.string "display_name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_private", default: false
    t.index ["account_id"], name: "index_profiles_on_account_id", unique: true
    t.index ["username"], name: "index_profiles_on_username", unique: true
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_reactions_on_account_id"
    t.index ["post_id"], name: "index_reactions_on_post_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "saved_posts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "post_id"], name: "index_saved_posts_on_account_id_and_post_id", unique: true
    t.index ["account_id"], name: "index_saved_posts_on_account_id"
    t.index ["post_id"], name: "index_saved_posts_on_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comment_reactions", "accounts"
  add_foreign_key "comment_reactions", "comments"
  add_foreign_key "comments", "accounts"
  add_foreign_key "comments", "posts"
  add_foreign_key "media_assets", "posts"
  add_foreign_key "posts", "accounts"
  add_foreign_key "reactions", "accounts"
  add_foreign_key "reactions", "posts"
  add_foreign_key "saved_posts", "accounts"
  add_foreign_key "saved_posts", "posts"
end

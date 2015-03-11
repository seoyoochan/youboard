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

ActiveRecord::Schema.define(version: 20150114092924) do

  create_table "attached_files", force: :cascade do |t|
    t.integer  "attachment_id",        limit: 4
    t.string   "file",                 limit: 255
    t.string   "content_type",         limit: 255
    t.integer  "file_size",            limit: 8
    t.string   "width",                limit: 255
    t.string   "height",               limit: 255
    t.string   "overall_content_type", limit: 255
    t.string   "extension",            limit: 255
    t.string   "original_name",        limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "attached_files", ["attachment_id"], name: "index_attached_files_on_attachment_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.integer  "attachable_id",    limit: 4
    t.string   "attachable_type",  limit: 255
    t.string   "attachment_token", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "attachments", ["user_id"], name: "index_attachments_on_user_id", using: :btree

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.integer  "user_id",    limit: 4
    t.string   "token",      limit: 255
    t.string   "secret",     limit: 255
    t.string   "username",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "boards", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "topic",       limit: 4
    t.text     "description", limit: 65535
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "publication", limit: 4
  end

  add_index "boards", ["user_id"], name: "index_boards_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   limit: 4,     default: 0
    t.string   "commentable_type", limit: 255
    t.string   "title",            limit: 255
    t.text     "body",             limit: 65535
    t.string   "subject",          limit: 255
    t.integer  "user_id",          limit: 4,     default: 0, null: false
    t.integer  "parent_id",        limit: 4
    t.integer  "lft",              limit: 4
    t.integer  "rgt",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "publication",      limit: 4
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "friend_id",   limit: 4
    t.string   "state",       limit: 255
    t.datetime "accepted_at"
    t.datetime "blocked_at"
    t.datetime "sent_at"
    t.datetime "received_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true, using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "body",             limit: 65535
    t.integer  "user_id",          limit: 4
    t.integer  "board_id",         limit: 4
    t.boolean  "allow_comment",    limit: 1
    t.string   "attachment_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "publication",      limit: 4
    t.boolean  "archived",         limit: 1
  end

  add_index "posts", ["board_id"], name: "index_posts_on_board_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "reportable_id",   limit: 4
    t.string   "reportable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "scraps", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scraps", ["post_id"], name: "index_scraps_on_post_id", using: :btree
  add_index "scraps", ["user_id"], name: "index_scraps_on_user_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.string   "subscribable_type", limit: 255
    t.integer  "subscribable_id",   limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",   null: false
    t.string   "encrypted_password",     limit: 255,   default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,     default: 0,    null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               limit: 255
    t.string   "name",                   limit: 255
    t.string   "gender",                 limit: 255
    t.date     "birthday"
    t.boolean  "agreement",              limit: 1,     default: true
    t.string   "last_name",              limit: 255
    t.string   "first_name",             limit: 255
    t.string   "job",                    limit: 255
    t.text     "description",            limit: 65535
    t.string   "website",                limit: 255
    t.string   "phone",                  limit: 255
    t.string   "locale",                 limit: 255
    t.string   "sns_avatar",             limit: 255
    t.string   "address",                limit: 255
    t.string   "facebook_account_url",   limit: 255
    t.string   "twitter_account_url",    limit: 255
    t.string   "linkedin_account_url",   limit: 255
    t.string   "github_account_url",     limit: 255
    t.string   "googleplus_account_url", limit: 255
    t.string   "avatar_id",              limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "views", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "viewable_id",   limit: 4
    t.string   "viewable_type", limit: 255
    t.string   "ip",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "views", ["user_id"], name: "index_views_on_user_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",          limit: 1,   default: false, null: false
    t.integer  "voteable_id",   limit: 4,                   null: false
    t.string   "voteable_type", limit: 255,                 null: false
    t.integer  "voter_id",      limit: 4
    t.string   "voter_type",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true, using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

  add_foreign_key "attached_files", "attachments"
  add_foreign_key "subscriptions", "users"
end

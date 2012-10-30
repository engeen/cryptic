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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121030220824) do

  create_table "accounts", :force => true do |t|
    t.integer  "account_type", :default => 1, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "calls", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "user_id"
    t.string   "reaction"
    t.text     "refusal_reason"
    t.string   "presentation_conditions"
    t.string   "result"
    t.datetime "next_date"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.datetime "meeting_date"
  end

  add_index "calls", ["issue_id", "user_id"], :name => "index_calls_on_issue_id_and_user_id"
  add_index "calls", ["issue_id"], :name => "index_calls_on_issue_id"
  add_index "calls", ["user_id"], :name => "index_calls_on_user_id"

  create_table "issues", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "client_name"
    t.string   "source"
    t.string   "phone"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "result"
  end

  add_index "issues", ["project_id", "user_id"], :name => "index_issues_on_project_id_and_user_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  add_index "users_accounts", ["user_id", "account_id"], :name => "index_users_accounts_on_user_id_and_account_id", :unique => true

  create_table "users_projects", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users_projects", ["user_id", "project_id"], :name => "index_users_projects_on_user_id_and_project_id", :unique => true

end

class UsersAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  
  attr_accessible :account_id, :role, :user_id
end

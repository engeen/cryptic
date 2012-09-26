class UsersAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  
  scope :by_role,  lambda {|user_role| where('role = ?', user_role) unless user_role.nil?}
  
  attr_accessible :account_id, :role, :user_id
end

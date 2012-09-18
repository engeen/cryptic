class Account < ActiveRecord::Base
  has_many :users_accounts
  has_many :users, :through => :users_accounts
  
  attr_accessible :account_type
  
  PERSONAL = 1
  
end

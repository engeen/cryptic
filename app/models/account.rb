class Account < ActiveRecord::Base
  has_many :users_accounts
  has_many :users, :through => :users_accounts

  has_many :projects
  
  attr_accessible :account_type
  
  PERSONAL = 1
  
  
  def owners
    users.by_role(:owner)
  end
  
  def members
    users.by_role(:member)
  end
  
  
end

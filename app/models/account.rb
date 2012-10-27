class Account < ActiveRecord::Base
  has_many :users_accounts
  has_many :users, :through => :users_accounts
  has_many :projects
  
  attr_accessible :account_type
  
  PERSONAL = 1
  COMPANY  = 2
  
  TYPES = { 1 => "personal", 2 => "company" }
  
  
  def owners
    users.by_role(:owner)
  end
  
  def members
    users.by_role(:member)
  end
  
  def name 
    @name ||= _name
  end
  
  
protected
  def _name
    aname = :personal if account_type == PERSONAL
    aname = :personal if account_type == COMPANY
    "#{I18n.t(:account_name, :scope => "account")} #{aname} ID:#{id}"
  end
  
  
end

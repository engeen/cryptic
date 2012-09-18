class Project < ActiveRecord::Base
  belongs_to :account
  has_many :users_projects
  has_many :users, :through => :users_projects

  attr_accessible :name
  
  
  scope :by_user,  lambda {|user| joins(:users_projects).where('users_projects.user_id = ?', user.id) unless user.nil?}
  
  def managers
    users.by_project_role(:manager)
  end
  
end

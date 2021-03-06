class UsersProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  attr_accessible :project_id, :user_id, :role
  
  ROLES=[:manager, :member]
end

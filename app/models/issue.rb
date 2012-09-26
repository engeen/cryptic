class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  has_many :calls
  
  scope :by_project,  lambda {|project| where('project_id = ?', project.id) unless project.nil?}
  scope :by_user,  lambda {|user| where('user_id = ?', user.id) unless user.nil?}
  
  attr_accessible :client_name, :phone, :project_id, :source, :user_id, :calls_attributes
  accepts_nested_attributes_for :calls

  SOURCES = [:cold, :recommendation, :retry]

end

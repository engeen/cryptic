# class IssueValidator < ActiveModel::Validator
#   # implement the method where the validation logic must reside
#   def validate(record)
#     # do my validations on the record and add errors if necessary
#     record.errors[:base] << "This is some custom error message" if record.calls.
#     record.errors[:first_name] << "This is some complex validation"
#   end
# end

class Issue < ActiveRecord::Base
  # include ActiveModel::IssueValidator
 
  belongs_to :project
  belongs_to :user
  
  has_many :calls, :validate => true
  
  scope :by_project,  lambda {|project| where('project_id = ?', project.id) unless project.nil?}
  scope :by_user,  lambda {|user| where('user_id = ?', user.id) unless user.nil?}
  
  attr_accessible :client_name, :phone, :project_id, :source, :user_id, :calls_attributes
  accepts_nested_attributes_for :calls

  SOURCES = [:cold, :recommendation, :retry]

  validates_presence_of :project_id, :user_id
  validates_length_of :source, :minimum => 3, :maximum => 100, :allow_blank => false

  validates :phone, :presence  => true
  
end

class IssueValidator < ActiveModel::Validator
  # implement the method where the validation logic must reside
  def validate(record)
    # do my validations on the record and add errors if necessary
    unless record.new_record?
      record.errors[:source] << "Source should be choosed" if record.source.blank? || !Issue.source_allowed?(record.source.to_sym)
    end
#    record.errors[:first_name] << "This is some complex validation"
    
#    super(record)
  end
end

class Issue < ActiveRecord::Base
  include ActiveModel::Validations 
  belongs_to :project
  belongs_to :user
  
  has_many :calls, :validate => true
  
  scope :by_project,  lambda {|project| where('project_id = ?', project.id) unless project.nil?}
  scope :by_user,  lambda {|user| where('user_id = ?', user.id) unless user.nil?}
  
  attr_accessible :client_name, :phone, :project_id, :source, :user_id, :calls_attributes
  accepts_nested_attributes_for :calls
  before_save :ensure_call_exists


  SOURCES = [:cold, :recommendation, :retry]

  validates_with IssueValidator
  validates_presence_of :project_id, :user_id, :phone
  validates :phone, :presence  => true,:numericality => true
  validates :client_name, :presence => { :if => lambda {|record| !record.new_record? }}
#  validate :calls
  
  def self.source_allowed?(source)
    SOURCES.include?(source)
  end
  
protected
  def ensure_call_exists
    calls.build if calls.length==0 && self.valid? && !self.new_record?
  end
  
  
end

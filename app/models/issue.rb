class IssueValidator < ActiveModel::Validator
  # implement the method where the validation logic must reside
  def validate(record)
    # do my validations on the record and add errors if necessary
    unless record.new_record?
      record.errors[:source] << I18n.t("activerecord.errors.models.issue.attributes.source.incorrect") if record.source.blank? || !Issue.source_allowed?(record.source.to_sym)
    end
#    record.errors[:first_name] << "This is some complex validation"
    
#    super(record)
  end
end

class Issue < ActiveRecord::Base
  include ActiveModel::Validations 
  belongs_to :project
  belongs_to :user
  
  has_many :calls, :validate => true, :order => "calls.created_at ASC"
  
  scope :by_project,  lambda {|project| where('issues.project_id = ?', project.id) unless project.nil?}
  scope :by_user,  lambda {|user| where('issues.user_id = ?', user.id) unless user.nil?}
  scope :by_source,  lambda {|source| where('issues.source = ?', source) unless source.nil?}
  
  scope :reminders, lambda { includes(:calls).where("calls.meeting_date > ?", Date.tomorrow).where("calls.created_at < ?", Date.today) }
#  default_scope order("issues.created_at DESC")
  
  attr_accessible :client_name, :phone, :project_id, :source, :user_id, :calls_attributes
  accepts_nested_attributes_for :calls,:reject_if => proc {|record_attrs| !record_attrs[:id].blank? }
  before_save :ensure_call_exists



  SOURCES = [:cold, :recommendation, :retry]
  SOURCES_SELECTION = SOURCES.inject({I18n.t("issue.sources.default") => ""}){ |c,e| c[I18n.t("issue.sources.#{e.to_s}")] = e.to_s; c}

  validates_with IssueValidator
  validates_presence_of :project_id, :user_id
  validates :phone, :presence  => true,:numericality => true
  validates :client_name, :presence => { :if => lambda {|record| !record.new_record? }}
  validate :calls
  
  
  def self.source_allowed?(source)
    SOURCES.include?(source)
  end
  
  
  def urgent?
    calls.last.next_date < 5.minutes.ago if calls.last && calls.last.next_date
  end



  def today?
    calls.last.next_date > Date.today && calls.last.next_date < Date.tomorrow if calls.last && calls.last.next_date
  end
  
  
  # def result
  #   last_call = calls.last
  #   last_call ? last_call.result : nil 
  # end
  
protected
  def ensure_call_exists
#    calls.build if calls.length==0 && self.valid? && !self.new_record?
  end
  
  def update_issue_result
    result = calls.last.result if calls.last
  end
  
  
end

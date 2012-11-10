class Call < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue
  
  attr_accessible :issue_id, :next_date, :meeting_date, :presentation_conditions, :reaction, :refusal_reason, :result, :user_id
  before_validation {|record| 
    record.result = :refusal.to_s if record.reaction==:instant_refusal.to_s
    record.result = :redial.to_s if record.reaction==:cant_speak.to_s
    record.user = record.issue.user if record.issue
    logger.warn "============= HERE WE CHANGING VALUE============= #{record.result} ==== where the record.reaction is #{record.reaction} == : #{ record.reaction==:instant_refusal.to_s}"
    logger.warn "============= HERE WE CHANGING VALUE============= #{record.user_id} ==== where the record.issue.user is #{record.issue.user_id if record.issue} "
  }
  after_save :update_issue_result
  
  
  REACTIONS = [:instant_refusal, :cant_speak, :listening, :interest, :asking]
  REACTIONS_SELECTION = REACTIONS.inject({I18n.t(:default, :scope => "call.reactions") => ""}){ |c,e| c[I18n.t(e, :scope => "call.reactions")] = e.to_s; c}


  CONDITIONS = [:complete, :partial, :none]
  CONDITIONS_SELECTION = CONDITIONS.inject({I18n.t(:default, :scope => "call.conditions") => ""}){ |c,e| c[I18n.t(e, :scope => "call.conditions")] = e.to_s; c}


  RESULTS = [:meeting, :redial, :refusal, :noanswer]
  RESULTS_SELECTION = RESULTS.inject({I18n.t(:default, :scope => "call.results") => ""}){ |c,e| c[I18n.t(e, :scope => "call.results")] = e.to_s; c}


  
  validates_presence_of :user_id, :if => lambda {|record| !record.new_record? }
  validates_presence_of :issue_id
  validates :result, :presence => true
  validates_presence_of :refusal_reason, :if => lambda {|record| record.result == :refusal.to_s }
  validates_presence_of :reaction, :unless => lambda {|record| record.result == :noanswer.to_s}
  validates_presence_of :presentation_conditions, :if => lambda{|record| [:redial.to_s, :refusal.to_s, :meeting.to_s].include?(record.result) }

#  validates_presence_of :meeting_date, :if => lambda {|record| record.result == :meeting.to_s }
#  validates_presence_of :next_date, :if => lambda {|record| [:redial.to_s,:noanswer.to_s].include?(record.result) }


  validates_datetime :next_date, :after => lambda { 2.minutes.since }, :if => lambda {|record| [:redial.to_s,:noanswer.to_s].include?(record.result) }
  validates_datetime :meeting_date, :after => lambda { 30.minutes.since }, :if => lambda {|record| record.result == :meeting.to_s }

#  validates :next_date, :timeliness => {:on_or_before => lambda { Date.current }, :type => :date}  

#  validate :meeting_date_valid_datetime

  # def meeting_date_valid_datetime
  #   errors.add(:meeting_date, 'must be a valid datetime') if ((DateTime.parse(meeting_date) rescue ArgumentError) == ArgumentError)
  # end



  
  def locked?
    !new_record?  && valid?
  end
  
  def result_needed?
    result != :refusal_reason.to_s
  end
  
  def conditions_needed?
#    [:redial.to_s, :refusal.to_s, :meeting.to_s].include?(result)
    true
  end
  
  def reason_needed?
    logger.warn "======= REASON NEEDED: #{result == :refusal.to_s} ---------result: #{result}"
    result == :refusal.to_s
  end
  
  def nextdate_needed?
    [:redial.to_s, :noanswer.to_s].include?(result)
  end
  
  def meetingdate_needed?
    result == :meeting.to_s
  end
  
  def update_issue_result
    issue.result = self.result 
    issue.save!
  end
  
end

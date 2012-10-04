class Call < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue
  
  attr_accessible :issue_id, :next_date, :presentation_conditions, :reaction, :refusal_reason, :result, :user_id
  
  
  REACTIONS = [:instant_refusal, :cant_speak, :listening, :interest, :asking]
  CONDITIONS = [:complete, :partial, :none]
  RESULTS = [:meeting, :redial, :refusal, :noanswer]
  
  validates_presence_of :user_id
  validates_presence_of :issue_id
  validates :result, :presence => true
  
  
end

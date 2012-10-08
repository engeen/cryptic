class AddMeetingDateToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :meeting_date, :datetime
  end
end

class AddNextDateToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :next_date, :datetime
    
    Issue.all.each do |i|
      if i.calls.count > 0
        last_call = i.calls.last
        i.next_date = last_call.next_date if last_call.next_date
        i.save
      end
    end
    
  end
  
  
  def self.down
    remove_column :issues, :next_date
  end
  
end

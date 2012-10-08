class AddResultToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :result, :string
  end
end

class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :issue_id
      t.integer :user_id
      t.string :reaction
      t.text :refusal_reason
      t.string :presentation_conditions
      t.string :result
      t.datetime :next_date

      t.timestamps
    end
    
    add_index :calls, [:issue_id, :user_id]
    add_index :calls, :issue_id
    add_index :calls, :user_id
  end
end

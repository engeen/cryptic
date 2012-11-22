class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :issue_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end

    add_index :comments, [:issue_id, :user_id]
  end
end

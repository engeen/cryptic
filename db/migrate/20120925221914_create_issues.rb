class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :project_id
      t.integer :user_id
      t.text :client_name
      t.string :source
      t.string :phone

      t.timestamps
    end

    add_index :issues, [:project_id, :user_id]
  end
end

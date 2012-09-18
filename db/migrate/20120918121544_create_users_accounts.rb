class CreateUsersAccounts < ActiveRecord::Migration
  def change
    create_table :users_accounts do |t|
      t.integer :user_id
      t.integer :account_id
      t.string :role

      t.timestamps
    end
    
    add_index :users_accounts, [:user_id, :account_id], :unique => true
    
  end
end

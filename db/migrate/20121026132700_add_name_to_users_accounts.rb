class AddNameToUsersAccounts < ActiveRecord::Migration
  def change
    add_column :users_accounts, :name, :string
  end
end

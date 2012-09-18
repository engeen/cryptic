class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :account_type, :default => 1, :null => false

      t.timestamps
    end
  end
end

class RemoveUnusedTables < ActiveRecord::Migration[7.2]
  def change
    drop_table :profiles if table_exists?(:profiles)
    drop_table :users if table_exists?(:users)
    drop_table :credentials if table_exists?(:credentials)
    drop_table :account_emails if table_exists?(:account_emails)
  end
end

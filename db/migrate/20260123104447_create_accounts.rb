class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
  # Add default: 'active' so status doesn't have to be set manually on registration
  # Add null: false so the status is never empty
      t.string :status, default: 'active', null: false

      t.timestamps
    end

  # Add an index. It will help the DB quickly find, for example,
  # all blocked users or only active ones.
    add_index :accounts, :status
  end
end
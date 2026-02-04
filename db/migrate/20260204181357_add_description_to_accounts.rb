class AddDescriptionToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :description, :text
  end
end

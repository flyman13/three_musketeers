class AddForeignKeysToRelationships < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :relationships, :accounts, column: :follower_id
    add_foreign_key :relationships, :accounts, column: :followed_id
  end
end

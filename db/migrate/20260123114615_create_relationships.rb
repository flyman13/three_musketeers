class CreateRelationships < ActiveRecord::Migration[7.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end

  # Indexes to improve lookup speed
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
  # Unique index so a user cannot follow the same person twice
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end

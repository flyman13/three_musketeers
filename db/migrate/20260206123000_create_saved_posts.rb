class CreateSavedPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_posts do |t|
      t.references :account, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

    add_index :saved_posts, [:account_id, :post_id], unique: true
  end
end

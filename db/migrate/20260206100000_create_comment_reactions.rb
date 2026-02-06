class CreateCommentReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :comment_reactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end

    add_index :comment_reactions, [:account_id, :comment_id], unique: true, name: 'index_comment_reactions_on_account_and_comment'
  end
end

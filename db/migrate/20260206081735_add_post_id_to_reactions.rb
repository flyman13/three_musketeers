class AddPostIdToReactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :reactions, :post, null: false, foreign_key: true
  end
end

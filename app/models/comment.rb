class Comment < ApplicationRecord
  # Built-in associations: comment belongs to an author and a post
  belongs_to :account
  belongs_to :post
  has_many :comment_reactions, dependent: :destroy

  validates :body, presence: true, length: { maximum: 500 }
end
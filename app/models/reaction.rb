class Reaction < ApplicationRecord
  # Only these two associations!
  belongs_to :account
  belongs_to :post

  # Validation: a musketeer can like a post only once
  validates :account_id, uniqueness: { scope: :post_id, message: "ви вже лайкнули цей допис" }
end
class Reaction < ApplicationRecord
  # Only these two associations!
  belongs_to :account
  # Keep convenience association to post (some code references it)
  belongs_to :post

  # Polymorphic target (post/comment)
  belongs_to :target, polymorphic: true, optional: false

  # Validation: a user can react to a target only once
  validates :account_id, uniqueness: { scope: [:target_id, :target_type], message: 'you already reacted' }
end

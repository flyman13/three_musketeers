class Relationship < ApplicationRecord
  # 1. Who follows (Follower)
  # We name the association :follower, but tell Rails:
  # "Actually look up the Account table (class_name)"
  belongs_to :follower, class_name: "Account"

  # 2. Who is being followed (Followed)
  # Same: name is :followed, but class is Account
  belongs_to :followed, class_name: "Account"

  # 3. Validations
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  # Built-in uniqueness validation: cannot follow the same person twice
  validates :follower_id, uniqueness: { scope: :followed_id, 
                                        message: "ви вже підписані" }
end
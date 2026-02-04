class Account < ApplicationRecord
  # Built-in method for password handling (requires the bcrypt gem)
  has_secure_password 

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  
  # Validations now live here because the Profile table was removed
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  # Accounts that follow YOU (Followers)
  # Change foreign_key from following_id to followed_id
  has_many :follower_relationships, foreign_key: :followed_id, class_name: "Relationship"
  has_many :followers, through: :follower_relationships, source: :follower

  # Accounts that YOU follow (Following)
  has_many :following_relationships, foreign_key: :follower_id, class_name: "Relationship"
  has_many :following, through: :following_relationships, source: :followed

  def following?(other_account)
    following.include?(other_account)
  end
end


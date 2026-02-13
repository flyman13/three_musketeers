class Account < ApplicationRecord
  # Built-in method for password handling (requires the bcrypt gem)
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :saved_posts, dependent: :destroy
  has_many :saved, through: :saved_posts, source: :post
  
  # For liked posts (reactions where target is a post)
  has_many :liked_posts, -> { where(reactions: { target_type: 'Post' }) }, through: :reactions, source: :target, source_type: 'Post'

  # Validations now live here because the Profile table was removed
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false } 
  validates :avatar,
            content_type: ['image/jpeg', 'image/png', 'image/webp'],
            size: { less_than: 5.megabytes },
            allow_nil: true 

  # Accounts that follow YOU (Followers)
  # Change foreign_key from following_id to followed_id
  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Relationship'
  has_many :followers, through: :follower_relationships, source: :follower

  # Accounts that YOU follow (Following)
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Relationship'
  has_many :following, through: :following_relationships, source: :followed

  def following?(other_account)
    following.include?(other_account)
  end

  scope :active, -> { where.not(username: nil) }
  scope :inactive, -> { where(username: nil) }
end

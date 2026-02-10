class Post < ApplicationRecord
  belongs_to :account
  has_many :comments, dependent: :destroy
  has_many :media_assets, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :saved_posts, dependent: :destroy
  has_many :savers, through: :saved_posts, source: :account
  has_one_attached :image

  validates :body, presence: true, length: { maximum: 1000 }
  # Image attachments are optional; when present, validate content type and size
  validates :image, content_type: ['image/jpeg', 'image/png', 'image/webp'], size: { less_than: 5.megabytes }, allow_nil: true

end

class Post < ApplicationRecord
  belongs_to :account
  has_many :comments, dependent: :destroy
  has_many :media_assets, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :saved_posts, dependent: :destroy
  has_many :savers, through: :saved_posts, source: :account
  has_one_attached :image, dependent: :destroy

  validates :account_id, presence: true
  validates :body, length: { maximum: 1000, message: "Текст не може бути довше 1000 символів" }, allow_blank: true
  validates :image, content_type: { with: ['image/jpeg', 'image/png', 'image/webp'], message: 'повинна бути JPG, PNG або WebP' }, size: { less_than: 5.megabytes, message: 'повинна бути менше 5 МБ' }, allow_nil: true

  validate :image_attached_or_body_present

  private

  def image_attached_or_body_present
    if body.blank? && !image.attached?
      errors.add(:base, "Пост повинен мати текст або зображення")
    end
  end
end

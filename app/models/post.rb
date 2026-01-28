class Post < ApplicationRecord
  belongs_to :account
  has_many :comments, dependent: :destroy
  has_many :media_assets, dependent: :destroy
  has_many :reactions, dependent: :destroy
  
  validates :body, presence: true, length: { maximum: 1000 } 
  validates :image, presence: true

  has_one_attached :image
end
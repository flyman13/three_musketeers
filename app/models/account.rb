class Account < ApplicationRecord
  # Built-in method for password handling (requires the bcrypt gem)
  has_secure_password 

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  
  # Validations now live here because the Profile table was removed
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
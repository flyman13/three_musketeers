class Relationship < ApplicationRecord
  # 1. Who follows (Follower)
  belongs_to :follower, class_name: "Account"

  # 2. Who is being followed (Followed)
  belongs_to :followed, class_name: "Account"

  # 3. Validations
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  # Заборона підписуватися на самого себе
  validate :cannot_follow_self

  # Built-in uniqueness validation: cannot follow the same person twice
  validates :follower_id, uniqueness: { scope: :followed_id, 
                                        message: "ви вже підписані" }

  private

  # Метод для перевірки ID
  def cannot_follow_self
    if follower_id == followed_id
      errors.add(:followed_id, "ви не можете підписатися на самого себе")
    end
  end
end
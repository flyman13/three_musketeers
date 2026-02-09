# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    association :follower, factory: :account
    association :followed, factory: :account
  end
end

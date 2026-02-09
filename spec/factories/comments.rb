# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :account
    association :post
    body { Faker::Lorem.sentence(word_count: 6) }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    username { Faker::Internet.unique.username(specifier: 5..12) }
  email { Faker::Internet.unique.email }
    password { 'password' }
    display_name { Faker::Name.name }
    bio { Faker::Lorem.sentence(word_count: 8) }
  end
end

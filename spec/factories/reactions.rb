# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    association :account
    association :post
    # default polymorphic target is the post
    association :target, factory: :post
    kind { 'like' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :media_asset do
    association :post
    asset_type { 'image' }
    position { 0 }
  end
end

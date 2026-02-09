# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :account
    body { Faker::Lorem.paragraph(sentence_count: 2) }

    trait :with_image do
      after(:build) do |post|
        # attach a sample fixture image if ActiveStorage is available
        if defined?(ActiveStorage::Blob)
          # prefer spec fixtures but fall back to legacy test fixtures if needed
          spec_path = Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')
          legacy_path = Rails.root.join('test_legacy', 'fixtures', 'files', 'test_image.png')
          file_path = File.exist?(spec_path) ? spec_path : legacy_path
          post.image.attach(io: File.open(file_path), filename: 'test_image.png', content_type: 'image/png') if File.exist?(file_path)
        end
      end
    end
  end
end

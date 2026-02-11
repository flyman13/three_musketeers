# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::CreatePostService, type: :service do
  describe '#call' do
    let(:account) { create(:account) }

    it 'creates a new post and increases Post.count by 1' do
      params = { body: 'A test body for the new post' }

      expect {
        described_class.new(account, params).call
      }.to change(Post, :count).by(1)
    end

    it 'returns a persisted post on success' do
      params = { body: 'Another post body' }
      post = described_class.new(account, params).call

  expect(post).to be_persisted
  expect(post.body).to eq('Another post body')
    end

    context 'with invalid params' do
      it 'does not create a post and returns an object with errors' do
        params = { body: '' }

        expect {
          described_class.new(account, params).call
        }.not_to change(Post, :count)

        post = described_class.new(account, params).call
        expect(post).not_to be_persisted
        expect(post.errors[:base]).to include("Пост повинен мати текст або зображення")
      end

      it 'does not create a post when body is blank and no image is provided' do
        params = { body: '', image: nil }

        expect {
          described_class.new(account, params).call
        }.not_to change(Post, :count)

        post = described_class.new(account, params).call
        expect(post).not_to be_persisted
        expect(post.errors[:base]).to include("Пост повинен мати текст або зображення")
      end

      it 'creates a post with only image when body is blank' do
        file_path = Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')
        uploaded = Rack::Test::UploadedFile.new(file_path, 'image/png')

        params = { body: '', image: uploaded }

        expect {
          described_class.new(account, params).call
        }.to change(Post, :count).by(1)

        post = described_class.new(account, params).call
        expect(post).to be_persisted
        expect(post.body).to be_blank
        expect(post.image).to be_attached
      end
    end

    context 'with image attachment' do
      it 'attaches the uploaded image to the post' do
  file_path = Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')
        uploaded = Rack::Test::UploadedFile.new(file_path, 'image/png')

        params = { body: 'Post with image', image: uploaded }
        post = described_class.new(account, params).call

        expect(post).to be_persisted
        expect(post.image).to be_attached
      end
    end

    context 'when account is nil' do
      it 'raises an ArgumentError and does not create a post' do
        params = { body: 'Should not be created' }

        expect { described_class.new(nil, params).call }.to raise_error(ArgumentError)
        expect(Post.where(body: 'Should not be created')).to be_empty
      end
    end
  end
end

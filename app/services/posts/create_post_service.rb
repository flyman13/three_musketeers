# frozen_string_literal: true

module Posts
  class CreatePostService
    attr_reader :account, :params, :post

    def initialize(account, params = {})
      @account = account
      @params = params
      @post = nil
    end

    # Create a post for the provided account using params.
    # Returns the post (saved or with errors attached).
    def call
      raise ArgumentError, 'account is required' unless account.present?

      @post = account.posts.build(post_params)

      attach_image_if_present

      begin
        @post.save
      rescue StandardError => e
        # Attach error to the model so callers can inspect it
        @post ||= Post.new(post_params)
        @post.errors.add(:base, e.message)
      end

      @post
    end

    private

    def post_params
      # duplicate params to avoid accidental mutation
      params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params.to_h
    end

    def attach_image_if_present
      return unless params && params[:image].present? && @post.respond_to?(:image)

      # If an uploaded file or Rack::Test uploaded file is provided, attach it
      @post.image.attach(params[:image])
    end
  end
end

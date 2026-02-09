require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:account) { create(:account) }

  describe 'GET #index' do
    let!(:post_record) { create(:post) }

    it 'returns http success and renders posts' do
      # sign in through the sessions controller to set session[:account_id]
      post login_path, params: { email: account.email, password: 'password' }

      get root_path

      expect(response).to have_http_status(:ok)
      # page should contain the post body
      expect(response.body).to include(CGI.escapeHTML(post_record.body))
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { post: { body: 'This is a test post' } } }

    it 'creates a post in the database and redirects (uses the service internally)' do
      # ensure controller's private post_params returns a plain hash to avoid a params-wrapping
      allow_any_instance_of(PostsController).to receive(:post_params).and_return(valid_params[:post])

      # sign in and then create
      post login_path, params: { email: account.email, password: 'password' }

      expect do
        post posts_path, params: valid_params
      end.to change(Post, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Post created!')
    end
  end

  describe 'POST #like' do
    let!(:post_record) { create(:post) }

    context 'when interactor succeeds' do
      it 'calls TogglePostLike and returns turbo-stream content' do
        result_double = double('result', success?: true, message: nil)

        expect(TogglePostLike).to receive(:call).with(account: account, post: post_record).and_return(result_double)

  # sign in to set session[:account_id]
  post login_path, params: { email: account.email, password: 'password' }

  headers = { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
  post like_post_path(post_record), headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        # turbo-stream should attempt to replace the like button target
        expect(response.body).to include("like_post_#{post_record.id}")
      end
    end

    context 'when interactor fails' do
      it 'prepends an alert into the turbo stream' do
        result_double = double('result', success?: false, message: 'Something went wrong')

        expect(TogglePostLike).to receive(:call).with(account: account, post: post_record).and_return(result_double)

  # sign in to set session[:account_id]
  post login_path, params: { email: account.email, password: 'password' }

  headers = { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
  post like_post_path(post_record), headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('turbo-stream')
        expect(response.body).to include('Something went wrong')
      end
    end
  end
end

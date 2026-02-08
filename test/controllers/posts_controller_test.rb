require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Додай це!

  setup do
    @account = accounts(:one)
    @post = posts(:one)
  sign_in_as(@account) # Now current_account in the controller will NOT be nil!
  end

  test "should get index" do
  get posts_url # this is the /posts route
    assert_response :success
  end

  test "should get new" do
  get new_post_url # this is the /posts/new route
    assert_response :success
  end

  test "should create post" do
    assert_difference("Post.count", 1) do
      post posts_url, params: { post: { body: "A long body to pass validation", image: fixture_file_upload('test_image.png', 'image/png') } }
    end
  assert_redirected_to root_url # Exactly root_url, as in your controller!
  end

  test "should show post" do
    get post_url(@post) # /posts/:id
    assert_response :success
  end

  test "should destroy post" do
    assert_difference("Post.count", -1) do
  # Deletion happens via DELETE /posts/:id
      delete post_url(@post)
    end
      assert_redirected_to root_url
  end
end
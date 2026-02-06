require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Додай це!

  setup do
    @account = accounts(:one)
    @post = posts(:one)
    sign_in_as(@account) # Тепер current_account у контролері НЕ буде nil!
  end

  test "should get index" do
    get posts_url # це роут /posts
    assert_response :success
  end

  test "should get new" do
    get new_post_url # це роут /posts/new
    assert_response :success
  end

  test "should create post" do
    assert_difference("Post.count", 1) do
      post posts_url, params: { post: { body: "A long body to pass validation", image: fixture_file_upload('test_image.png', 'image/png') } }
    end
    assert_redirected_to root_url # Саме root_url, як у твоєму контролері!
  end

  test "should show post" do
    get post_url(@post) # /posts/:id
    assert_response :success
  end

  test "should destroy post" do
    assert_difference("Post.count", -1) do
      # У вас видалення через DELETE /posts/:id
      delete post_url(@post)
    end
      assert_redirected_to root_url
  end
end
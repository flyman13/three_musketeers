require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:one)
    sign_in_as(@account)
  end

  test "should get show" do
    get user_profile_url(@account.id)
    assert_response :success
  end
end
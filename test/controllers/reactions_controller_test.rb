require "test_helper"

class ReactionsControllerTest < ActionDispatch::IntegrationTest
  test "should create reaction" do
    new_account = Account.create!(username: 'liker', email: 'liker@example.com', password: 'password')
    sign_in_as new_account

    assert_difference 'Reaction.count', 1 do
      post reactions_url, params: { post_id: posts(:one).id }
    end

    assert_redirected_to root_path
  end

  test "should destroy reaction" do
    sign_in_as accounts(:one)
    reaction = reactions(:one)

    assert_difference 'Reaction.count', -1 do
      delete reaction_url(reaction)
    end

    assert_redirected_to root_path
  end
end

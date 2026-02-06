require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should create relationship" do
    # create a temporary account to follow someone
    new_account = Account.create!(username: 'newbie', email: 'newbie@example.com', password: 'password')
    sign_in_as new_account

    assert_difference 'Relationship.count', 1 do
      post relationships_url, params: { followed_id: accounts(:one).id }
    end

    assert_redirected_to root_path
  end

  test "should destroy relationship" do
    sign_in_as accounts(:one)
    relationship = relationships(:one)

    assert_difference 'Relationship.count', -1 do
      delete relationship_url(relationship)
    end

    assert_redirected_to root_path
  end
end

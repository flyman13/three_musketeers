require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should create comment" do
    sign_in_as accounts(:one)

    assert_difference 'Comment.count', 1 do
      post post_comments_url(posts(:one)), params: { comment: { body: 'A test comment' } }
    end

    assert_redirected_to root_path
  end

  test "should destroy comment" do
    sign_in_as accounts(:one)
    comment = comments(:one)

    assert_difference 'Comment.count', -1 do
      delete post_comment_url(comment.post, comment)
    end

    assert_redirected_to root_path
  end

  test "should like and unlike comment" do
    sign_in_as accounts(:two)
    comment = comments(:one)

    assert_difference 'CommentReaction.count', 1 do
      post like_post_comment_url(post_id: comment.post.id, id: comment.id)
    end

    assert_redirected_to root_path

    assert_difference 'CommentReaction.count', -1 do
      delete unlike_post_comment_url(post_id: comment.post.id, id: comment.id)
    end

    assert_redirected_to root_path
  end
end

require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should not save comment without content" do
    comment = Comment.new(user: users(:regular), post: posts(:one))
    assert_not comment.save
  end

  test "should belong to user and post" do
    comment = comments(:one)
    assert_not_nil comment.user
    assert_not_nil comment.post
  end
end

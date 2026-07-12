require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should not save post without title" do
    post = Post.new(content: "Some content", user: users(:regular))
    assert_not post.save
  end

  test "should belong to user" do
    post = posts(:one)
    assert_not_nil post.user
  end

  test "should have many comments" do
    post = posts(:one)
    assert post.comments.count >= 1
  end
end

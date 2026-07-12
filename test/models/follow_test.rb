require "test_helper"

class FollowTest < ActiveSupport::TestCase
  test "should not allow following self" do
    user = users(:regular)
    follow = Follow.new(follower: user, following: user)
    assert_not follow.save
  end

  test "should not allow duplicate follow" do
    follow = Follow.new(follower: users(:regular), following: users(:other))
    assert_not follow.save
  end
end

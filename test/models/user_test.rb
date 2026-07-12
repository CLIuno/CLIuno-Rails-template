require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new(first_name: "Test", last_name: "User", email: "test@example.com", password: "password123")
    assert_not user.save
  end

  test "should not save user without email" do
    user = User.new(username: "testuser", first_name: "Test", last_name: "User", password: "password123")
    assert_not user.save
  end

  test "should not save user with duplicate username" do
    user = User.new(username: users(:regular).username, first_name: "Test", last_name: "User",
                    email: "unique@example.com", password: "password123")
    assert_not user.save
  end

  test "should authenticate with correct password" do
    user = users(:regular)
    assert user.authenticate("password123")
  end

  test "should not authenticate with wrong password" do
    user = users(:regular)
    assert_not user.authenticate("wrongpassword")
  end

  test "admin? returns true for admin role" do
    assert users(:admin).admin?
  end

  test "admin? returns false for user role" do
    assert_not users(:regular).admin?
  end

  test "soft_delete! sets is_deleted and deleted_at" do
    user = users(:regular)
    user.soft_delete!
    assert user.is_deleted
    assert_not_nil user.deleted_at
  end
end

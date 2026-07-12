require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "should not save role without name" do
    role = Role.new
    assert_not role.save
  end

  test "should not save role with duplicate name" do
    role = Role.new(name: roles(:admin).name)
    assert_not role.save
  end

  test "should have many users" do
    role = roles(:user)
    assert role.users.count >= 1
  end
end

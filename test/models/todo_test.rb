require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "should not save todo without title" do
    todo = Todo.new(description: "Some description", user: users(:regular))
    assert_not todo.save
  end

  test "should belong to user" do
    todo = todos(:one)
    assert_not_nil todo.user
  end

  test "should default to not completed" do
    todo = Todo.create!(title: "Test Todo", user: users(:regular))
    assert_not todo.is_completed
  end
end

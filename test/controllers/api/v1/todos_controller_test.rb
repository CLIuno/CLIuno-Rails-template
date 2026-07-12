require "test_helper"

class Api::V1::TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
    @todo = todos(:one)
  end

  test "should get all todos" do
    get api_v1_todos_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["todos"].length >= 2
  end

  test "should get current user todos" do
    get api_v1_todos_current_user_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "should get todo by id" do
    get api_v1_todo_url(@todo), headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @todo.title, json["data"]["todo"]["title"]
  end

  test "should create todo" do
    assert_difference("Todo.count") do
      post api_v1_todos_url, params: { title: "New Todo", description: "Do something" },
           headers: auth_headers_for(@user), as: :json
    end

    assert_response :created
  end

  test "should update todo" do
    patch api_v1_todo_url(@todo), params: { title: "Updated Todo" },
          headers: auth_headers_for(@user), as: :json

    assert_response :success
    @todo.reload
    assert_equal "Updated Todo", @todo.title
  end

  test "should delete todo" do
    assert_difference("Todo.count", -1) do
      delete api_v1_todo_url(@todo), headers: auth_headers_for(@user), as: :json
    end

    assert_response :success
  end

  test "should toggle todo completion" do
    patch toggle_api_v1_todo_url(@todo), headers: auth_headers_for(@user), as: :json

    assert_response :success
    @todo.reload
    assert @todo.is_completed
  end

  test "should not create todo without title" do
    assert_no_difference("Todo.count") do
      post api_v1_todos_url, params: { description: "No title" },
           headers: auth_headers_for(@user), as: :json
    end

    assert_response :unprocessable_entity
  end
end

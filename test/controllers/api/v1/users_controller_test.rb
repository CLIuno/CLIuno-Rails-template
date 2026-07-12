require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
    @admin = users(:admin)
    @other = users(:other)
  end

  test "should get current user" do
    get api_v1_users_current_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @user.username, json["data"]["user"]["username"]
  end

  test "should update current user" do
    patch api_v1_users_current_url, params: { first_name: "Updated" },
          headers: auth_headers_for(@user), as: :json

    assert_response :success
    @user.reload
    assert_equal "Updated", @user.first_name
  end

  test "should soft delete current user" do
    delete api_v1_users_current_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
    @user.reload
    assert @user.is_deleted
  end

  test "should get user by username" do
    get "/api/v1/users/username/#{@other.username}", headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @other.username, json["data"]["user"]["username"]
  end

  test "should get user by id" do
    get "/api/v1/users/#{@other.id}", headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "admin should get all users" do
    get api_v1_users_url, headers: auth_headers_for(@admin), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["users"].length >= 3
  end

  test "non-admin should not get all users" do
    get api_v1_users_url, headers: auth_headers_for(@user), as: :json

    assert_response :forbidden
  end

  test "admin should update any user" do
    patch "/api/v1/users/#{@other.id}", params: { first_name: "AdminUpdated" },
          headers: auth_headers_for(@admin), as: :json

    assert_response :success
    @other.reload
    assert_equal "AdminUpdated", @other.first_name
  end

  test "admin should delete any user" do
    delete "/api/v1/users/#{@other.id}", headers: auth_headers_for(@admin), as: :json

    assert_response :success
    @other.reload
    assert @other.is_deleted
  end

  test "should not access without token" do
    get api_v1_users_current_url, as: :json

    assert_response :unauthorized
  end
end

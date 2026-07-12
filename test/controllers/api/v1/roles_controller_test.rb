require "test_helper"

class Api::V1::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:regular)
    @role = roles(:user)
  end

  test "admin should get all roles" do
    get api_v1_roles_url, headers: auth_headers_for(@admin), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["roles"].length >= 2
  end

  test "admin should get role by id" do
    get api_v1_role_url(@role), headers: auth_headers_for(@admin), as: :json

    assert_response :success
  end

  test "admin should create role" do
    assert_difference("Role.count") do
      post api_v1_roles_url, params: { name: "moderator" },
           headers: auth_headers_for(@admin), as: :json
    end

    assert_response :created
  end

  test "admin should update role" do
    patch api_v1_role_url(@role), params: { name: "updated_user" },
          headers: auth_headers_for(@admin), as: :json

    assert_response :success
    @role.reload
    assert_equal "updated_user", @role.name
  end

  test "admin should delete role" do
    role = Role.create!(name: "temp_role")
    assert_difference("Role.count", -1) do
      delete api_v1_role_url(role), headers: auth_headers_for(@admin), as: :json
    end

    assert_response :success
  end

  test "admin should get users by role" do
    get users_api_v1_role_url(@role), headers: auth_headers_for(@admin), as: :json

    assert_response :success
  end

  test "non-admin should not access roles" do
    get api_v1_roles_url, headers: auth_headers_for(@user), as: :json

    assert_response :forbidden
  end
end

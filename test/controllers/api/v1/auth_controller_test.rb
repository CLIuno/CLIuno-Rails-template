require "test_helper"

class Api::V1::AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
    @admin = users(:admin)
  end

  test "should register a new user" do
    assert_difference("User.count") do
      post api_v1_auth_register_url, params: {
        username: "newuser",
        first_name: "New",
        last_name: "User",
        email: "newuser@example.com",
        password: "password123",
        password_confirmation: "password123"
      }, as: :json
    end

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_not_nil json["data"]["token"]
    assert_not_nil json["data"]["refresh_token"]
  end

  test "should not register with duplicate username" do
    assert_no_difference("User.count") do
      post api_v1_auth_register_url, params: {
        username: @user.username,
        first_name: "Dup",
        last_name: "User",
        email: "dup@example.com",
        password: "password123",
        password_confirmation: "password123"
      }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should login with username" do
    post api_v1_auth_login_url, params: {
      username_or_email: @user.username,
      password: "password123"
    }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_not_nil json["data"]["token"]
  end

  test "should login with email" do
    post api_v1_auth_login_url, params: {
      username_or_email: @user.email,
      password: "password123"
    }, as: :json

    assert_response :success
  end

  test "should not login with wrong password" do
    post api_v1_auth_login_url, params: {
      username_or_email: @user.username,
      password: "wrongpassword"
    }, as: :json

    assert_response :unauthorized
  end

  test "should logout" do
    post api_v1_auth_logout_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "should refresh token" do
    refresh_token = JwtService.encode_refresh(user_id: @user.id)
    @user.update!(refresh_token: refresh_token)

    post api_v1_auth_refresh_token_url, params: { refresh_token: refresh_token }, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_not_nil json["data"]["token"]
  end

  test "should check token" do
    post api_v1_auth_check_token_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "should change password" do
    post api_v1_auth_change_password_url, params: {
      current_password: "password123",
      new_password: "newpassword123"
    }, headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "should not change password with wrong current password" do
    post api_v1_auth_change_password_url, params: {
      current_password: "wrongpassword",
      new_password: "newpassword123"
    }, headers: auth_headers_for(@user), as: :json

    assert_response :unprocessable_entity
  end
end

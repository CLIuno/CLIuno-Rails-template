require "test_helper"

class Api::V1::AuthFeaturesTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
  end

  test "forgot password stores a reset token for a known email" do
    post api_v1_auth_forgot_password_url, params: { email: @user.email }, as: :json

    assert_response :success
    assert_not_nil @user.reload.reset_password_token
  end

  test "forgot password is silent for an unknown email" do
    post api_v1_auth_forgot_password_url, params: { email: "nobody@example.com" }, as: :json

    assert_response :success
  end

  test "reset password with a valid token" do
    post api_v1_auth_forgot_password_url, params: { email: @user.email }, as: :json
    token = @user.reload.reset_password_token

    post api_v1_auth_reset_password_url, params: { password: "NewPass123", token: token }, as: :json
    assert_response :success

    post api_v1_auth_login_url, params: { usernameOrEmail: @user.username, password: "NewPass123" }, as: :json
    assert_response :success
  end

  test "reset password rejects an invalid token" do
    post api_v1_auth_reset_password_url, params: { password: "NewPass123", token: "bogus" }, as: :json

    assert_response :bad_request
  end

  test "send and verify email" do
    post api_v1_auth_send_verify_email_url, headers: auth_headers_for(@user), as: :json
    assert_response :success

    token = @user.reload.verify_token
    assert_not_nil token

    post api_v1_auth_verify_email_url, params: { token: token }, as: :json
    assert_response :success
    assert @user.reload.is_verified
  end

  test "full otp lifecycle" do
    post api_v1_auth_otp_generate_url, headers: auth_headers_for(@user), as: :json
    assert_response :success
    secret = JSON.parse(response.body)["data"]["secret"]
    assert_not_nil secret

    code = ROTP::TOTP.new(secret).now
    post api_v1_auth_otp_verify_url, params: { otp: code }, headers: auth_headers_for(@user), as: :json
    assert_response :success
    assert @user.reload.is_otp_enabled

    post api_v1_auth_otp_validate_url, params: { otp: ROTP::TOTP.new(secret).now },
                                       headers: auth_headers_for(@user), as: :json
    assert_response :success

    post api_v1_auth_otp_disable_url, headers: auth_headers_for(@user), as: :json
    assert_response :success
    assert_not @user.reload.is_otp_enabled
    assert_nil @user.reload.otp_secret
  end

  test "otp verify rejects a wrong code" do
    post api_v1_auth_otp_generate_url, headers: auth_headers_for(@user), as: :json

    post api_v1_auth_otp_verify_url, params: { otp: "000000" }, headers: auth_headers_for(@user), as: :json
    assert_response :unauthorized
  end

  test "otp validate without setup" do
    post api_v1_auth_otp_validate_url, params: { otp: "123456" }, headers: auth_headers_for(@user), as: :json

    assert_response :bad_request
  end
end

require "test_helper"

class Api::V1::FollowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
    @other = users(:other)
    @admin = users(:admin)
  end

  test "should follow a user" do
    # First unfollow if exists
    Follow.find_by(follower: @user, following: @other)&.destroy

    assert_difference("Follow.count") do
      post "/api/v1/follows/#{@admin.id}/follow", headers: auth_headers_for(@user), as: :json
    end

    assert_response :created
  end

  test "should not follow self" do
    assert_no_difference("Follow.count") do
      post "/api/v1/follows/#{@user.id}/follow", headers: auth_headers_for(@user), as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should unfollow a user" do
    assert_difference("Follow.count", -1) do
      delete "/api/v1/follows/#{@other.id}/follow", headers: auth_headers_for(@user), as: :json
    end

    assert_response :success
  end

  test "should get followers" do
    get "/api/v1/follows/#{@other.id}/followers", headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["followers"].length >= 1
  end

  test "should get following" do
    get "/api/v1/follows/#{@user.id}/following", headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "should check is following" do
    get "/api/v1/follows/#{@other.id}/is-following", headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["isFollowing"]
  end
end

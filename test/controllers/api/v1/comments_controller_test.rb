require "test_helper"

class Api::V1::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
    @post = posts(:one)
    @comment = comments(:one)
  end

  test "should get comments for post" do
    get api_v1_post_comments_url(@post), headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["comments"].length >= 1
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post api_v1_post_comments_url(@post), params: { content: "New comment" },
           headers: auth_headers_for(@user), as: :json
    end

    assert_response :created
  end

  test "should update comment" do
    patch api_v1_post_comment_url(@post, @comment), params: { content: "Updated comment" },
          headers: auth_headers_for(@user), as: :json

    assert_response :success
    @comment.reload
    assert_equal "Updated comment", @comment.content
  end

  test "should delete comment" do
    assert_difference("Comment.count", -1) do
      delete api_v1_post_comment_url(@post, @comment), headers: auth_headers_for(@user), as: :json
    end

    assert_response :success
  end

  test "should not create comment without content" do
    assert_no_difference("Comment.count") do
      post api_v1_post_comments_url(@post), params: { content: "" },
           headers: auth_headers_for(@user), as: :json
    end

    assert_response :unprocessable_entity
  end
end

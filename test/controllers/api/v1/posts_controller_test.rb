require "test_helper"

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
    @post = posts(:one)
  end

  test "should get all posts" do
    get api_v1_posts_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["posts"].length >= 2
  end

  test "should get current user posts" do
    get api_v1_posts_current_user_url, headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "should get post by id" do
    get api_v1_post_url(@post), headers: auth_headers_for(@user), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @post.title, json["data"]["post"]["title"]
  end

  test "should create post" do
    assert_difference("Post.count") do
      post api_v1_posts_url, params: { title: "New Post", content: "Post content" },
           headers: auth_headers_for(@user), as: :json
    end

    assert_response :created
  end

  test "should update post" do
    patch api_v1_post_url(@post), params: { title: "Updated Post" },
          headers: auth_headers_for(@user), as: :json

    assert_response :success
    @post.reload
    assert_equal "Updated Post", @post.title
  end

  test "should delete post" do
    assert_difference("Post.count", -1) do
      delete api_v1_post_url(@post), headers: auth_headers_for(@user), as: :json
    end

    assert_response :success
  end

  test "should get post author" do
    get user_api_v1_post_url(@post), headers: auth_headers_for(@user), as: :json

    assert_response :success
  end

  test "should not create post without title" do
    assert_no_difference("Post.count") do
      post api_v1_posts_url, params: { content: "No title" },
           headers: auth_headers_for(@user), as: :json
    end

    assert_response :unprocessable_entity
  end
end

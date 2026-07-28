class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show update destroy user]

  # GET /api/v1/posts
  def index
    posts = Post.includes(:user, comments: :user).order(created_at: :desc)
    render_success({ posts: posts.as_json(include: { user: { except: %i[password_digest refresh_token] }, comments: { include: { user: { except: %i[password_digest refresh_token] } } } }) })
  end

  # GET /api/v1/posts/current-user
  def current_user_posts
    posts = current_user.posts.includes(:comments).order(created_at: :desc)
    render_success({ posts: posts.as_json(include: :comments) })
  end

  # GET /api/v1/posts/:id
  def show
    render_success({ post: @post.as_json(include: { user: { except: %i[password_digest refresh_token] }, comments: { include: { user: { except: %i[password_digest refresh_token] } } } }) })
  end

  # POST /api/v1/posts
  def create
    post = current_user.posts.build(post_params)

    if post.save
      render_success({ post: post }, "Post created successfully", :created)
    else
      render_error("Post creation failed", :unprocessable_entity, post.errors.full_messages)
    end
  end

  # PATCH /api/v1/posts/:id
  def update
    if @post.update(post_params)
      render_success({ post: @post }, "Post updated successfully")
    else
      render_error("Post update failed", :unprocessable_entity, @post.errors.full_messages)
    end
  end

  # DELETE /api/v1/posts/:id
  def destroy
    @post.destroy!
    render_success({}, "Post deleted successfully")
  end

  # GET /api/v1/posts/:post_id/user
  def user
    render_success({ user: @post.user })
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id] || params[:post_id])
    render_not_found("Post not found") unless @post
  end

  def post_params
    # frontends may send either casing; image_url is what goes back out
    permitted = params.permit(:title, :content, :image_url, :imageUrl, :is_paid)
    permitted[:image_url] = permitted.delete(:imageUrl) if permitted[:image_url].blank? && permitted[:imageUrl].present?
    permitted.except(:imageUrl)
  end
end

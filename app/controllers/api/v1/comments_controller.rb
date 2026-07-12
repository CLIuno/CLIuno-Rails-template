class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: %i[update destroy]

  # GET /api/v1/posts/:post_id/comments
  def index
    comments = @post.comments.includes(:user).order(created_at: :desc)
    render_success({ comments: comments.as_json(include: { user: { except: %i[password_digest refresh_token] } }) })
  end

  # POST /api/v1/posts/:post_id/comments
  def create
    comment = @post.comments.build(comment_params.merge(user: current_user))

    if comment.save
      render_success({ comment: comment.as_json(include: { user: { except: %i[password_digest refresh_token] } }) }, "Comment created successfully", :created)
    else
      render_error("Comment creation failed", :unprocessable_entity, comment.errors.full_messages)
    end
  end

  # PATCH /api/v1/posts/:post_id/comments/:id
  def update
    if @comment.update(comment_params)
      render_success({ comment: @comment }, "Comment updated successfully")
    else
      render_error("Comment update failed", :unprocessable_entity, @comment.errors.full_messages)
    end
  end

  # DELETE /api/v1/posts/:post_id/comments/:id
  def destroy
    @comment.destroy!
    render_success({}, "Comment deleted successfully")
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
    render_not_found("Post not found") unless @post
  end

  def set_comment
    @comment = @post.comments.find_by(id: params[:id])
    render_not_found("Comment not found") unless @comment
  end

  def comment_params
    params.permit(:content)
  end
end

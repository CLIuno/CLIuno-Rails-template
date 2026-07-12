class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target_user, only: %i[follow unfollow followers following is_following]

  # POST /api/v1/follows/:user_id/follow
  def follow
    follow = current_user.active_follows.build(following: @target_user)

    if follow.save
      render_success({ follow: follow }, "Followed successfully", :created)
    else
      render_error("Follow failed", :unprocessable_entity, follow.errors.full_messages)
    end
  end

  # DELETE /api/v1/follows/:user_id/follow
  def unfollow
    follow = current_user.active_follows.find_by(following: @target_user)
    return render_not_found("Not following this user") unless follow

    follow.destroy!
    render_success({}, "Unfollowed successfully")
  end

  # GET /api/v1/follows/:user_id/followers
  def followers
    followers = @target_user.follower_users
    render_success({ followers: followers })
  end

  # GET /api/v1/follows/:user_id/following
  def following
    following = @target_user.following_users
    render_success({ following: following })
  end

  # GET /api/v1/follows/:user_id/is-following
  def is_following
    is_following = current_user.active_follows.exists?(following: @target_user)
    render_success({ is_following: is_following })
  end

  private

  def set_target_user
    @target_user = User.active.find_by(id: params[:user_id])
    render_not_found("User not found") unless @target_user
  end
end

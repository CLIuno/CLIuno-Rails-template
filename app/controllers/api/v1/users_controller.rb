class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: %i[index update_user delete_user]
  before_action :set_user, only: %i[show update_user delete_user]

  # GET /api/v1/users
  def index
    users = User.active.includes(:role)
    render_success({ users: users })
  end

  # GET /api/v1/users/current
  def current
    render_success({ user: current_user.as_json(include: :role) })
  end

  # PATCH /api/v1/users/current
  def update_current
    if current_user.update(current_user_params)
      render_success({ user: current_user }, "User updated successfully")
    else
      render_error("Update failed", :unprocessable_entity, current_user.errors.full_messages)
    end
  end

  # DELETE /api/v1/users/current
  def delete_current
    current_user.soft_delete!
    render_success({}, "User deleted successfully")
  end

  # GET /api/v1/users/username/:username
  def by_username
    user = User.active.find_by(username: params[:username])
    return render_not_found("User not found") unless user

    render_success({ user: user.as_json(include: :role) })
  end

  # GET /api/v1/users/:id
  def show
    render_success({ user: @user.as_json(include: :role) })
  end

  # GET /api/v1/users/posts
  def posts
    user = User.active.find_by(id: params[:user_id])
    return render_not_found("User not found") unless user

    posts = user.posts.includes(:user, :comments)
    render_success({ posts: posts.as_json(include: %i[user comments]) })
  end

  # GET /api/v1/users/role
  def role
    user = User.active.find_by(id: params[:user_id])
    return render_not_found("User not found") unless user

    render_success({ role: user.role })
  end

  # PATCH /api/v1/users/:id (admin)
  def update_user
    if @user.update(admin_user_params)
      render_success({ user: @user }, "User updated successfully")
    else
      render_error("Update failed", :unprocessable_entity, @user.errors.full_messages)
    end
  end

  # DELETE /api/v1/users/:id (admin)
  def delete_user
    @user.soft_delete!
    render_success({}, "User deleted successfully")
  end

  private

  def set_user
    @user = User.active.find_by(id: params[:id])
    render_not_found("User not found") unless @user
  end

  def current_user_params
    params.permit(:first_name, :last_name, :date_of_birth, :gender, :nationality, :phone)
  end

  def admin_user_params
    params.permit(:first_name, :last_name, :username, :email, :phone, :date_of_birth,
                  :gender, :nationality, :role_id, :is_online, :is_deleted)
  end
end

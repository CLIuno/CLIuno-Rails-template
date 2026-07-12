class Api::V1::AuthController < ApplicationController
  before_action :authenticate_user!, only: %i[check_token change_password]

  # POST /api/v1/auth/register
  def register
    role = Role.find_by(name: "user")
    user = User.new(register_params.merge(role: role))

    if user.save
      token = JwtService.encode(user_id: user.id)
      refresh_token = JwtService.encode_refresh(user_id: user.id)
      user.update!(refresh_token: refresh_token)

      render_success({ user: user, token: token, refresh_token: refresh_token }, "User registered successfully", :created)
    else
      render_error("Registration failed", :unprocessable_entity, user.errors.full_messages)
    end
  end

  # POST /api/v1/auth/login
  def login
    login_param = params[:usernameOrEmail] || params[:username_or_email]
    user = User.active.find_by("username = :login OR email = :login", login: login_param)

    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      refresh_token = JwtService.encode_refresh(user_id: user.id)
      user.update!(refresh_token: refresh_token, is_online: true)

      render_success({ user: user, token: token, refresh_token: refresh_token }, "Login successful")
    else
      render_error("Invalid credentials", :unauthorized)
    end
  end

  # POST /api/v1/auth/logout
  def logout
    token = extract_token
    if token
      BlacklistedToken.create(token: token)
      decoded = JwtService.decode(token)
      User.find_by(id: decoded&.dig(:user_id))&.update(is_online: false, refresh_token: nil)
    end

    render_success({}, "Logged out successfully")
  end

  # POST /api/v1/auth/refresh-token
  def refresh_token
    token = params[:refreshToken] || params[:refresh_token]
    return render_error("Refresh token required", :bad_request) unless token

    decoded = JwtService.decode_refresh(token)
    return render_error("Invalid or expired refresh token", :unauthorized) unless decoded

    user = User.active.find_by(id: decoded[:user_id])
    return render_error("User not found", :unauthorized) unless user
    return render_error("Invalid refresh token", :unauthorized) unless user.refresh_token == token

    new_token = JwtService.encode(user_id: user.id)
    new_refresh_token = JwtService.encode_refresh(user_id: user.id)
    user.update!(refresh_token: new_refresh_token)

    render_success({ token: new_token, refresh_token: new_refresh_token }, "Token refreshed successfully")
  end

  # POST /api/v1/auth/check-token
  def check_token
    render_success({ user: current_user }, "Token is valid")
  end

  # POST /api/v1/auth/change-password
  def change_password
    current_password = params[:oldPassword] || params[:current_password]
    new_password = params[:newPassword] || params[:new_password]
    unless current_user.authenticate(current_password)
      return render_error("Current password is incorrect", :unprocessable_entity)
    end

    if current_user.update(password: new_password)
      render_success({}, "Password changed successfully")
    else
      render_error("Password change failed", :unprocessable_entity, current_user.errors.full_messages)
    end
  end

  private

  def register_params
    params.permit(:username, :first_name, :last_name, :email, :phone, :password, :password_confirmation,
                  :date_of_birth, :gender, :nationality)
  end
end

class Api::V1::AuthController < ApplicationController
  before_action :authenticate_user!,
                only: %i[check_token change_password send_verify_email otp_generate otp_verify otp_validate otp_disable]

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

  # POST /api/v1/auth/forgot-password
  def forgot_password
    user = User.active.find_by(email: params[:email])
    # In production, email the token; templates keep it local to the database.
    user&.update!(reset_password_token: SecureRandom.urlsafe_base64(32))

    render_success({}, "If the email exists, a reset link has been sent")
  end

  # POST /api/v1/auth/reset-password
  def reset_password
    token = params[:token]
    user = token.present? ? User.active.find_by(reset_password_token: token) : nil
    return render_error("Invalid or expired reset token", :bad_request) unless user

    if user.update(password: params[:password], reset_password_token: nil)
      render_success({}, "Password has been reset successfully")
    else
      render_error("Password reset failed", :unprocessable_entity, user.errors.full_messages)
    end
  end

  # POST /api/v1/auth/send-verify-email
  def send_verify_email
    # In production, email the token; templates keep it local to the database.
    current_user.update!(verify_token: SecureRandom.urlsafe_base64(32))

    render_success({}, "Verification email sent")
  end

  # POST /api/v1/auth/verify-email
  def verify_email
    token = params[:token]
    user = token.present? ? User.active.find_by(verify_token: token) : nil
    return render_error("Invalid or expired verification token", :bad_request) unless user

    user.update!(is_verified: true, verify_token: nil)
    render_success({}, "Email verified successfully")
  end

  # POST /api/v1/auth/otp/generate
  def otp_generate
    secret = ROTP::Base32.random
    current_user.update!(otp_secret: secret, is_otp_enabled: false)

    otpauth_url = ROTP::TOTP.new(secret, issuer: "CLIuno").provisioning_uri(current_user.username)
    render_success({ secret: secret, otpauth_url: otpauth_url }, "OTP secret generated")
  end

  # POST /api/v1/auth/otp/verify
  def otp_verify
    return render_error("OTP is not set up", :bad_request) if current_user.otp_secret.blank?
    unless valid_otp?(params[:otp])
      return render_error("Invalid OTP code", :unauthorized)
    end

    current_user.update!(is_otp_enabled: true)
    render_success({}, "OTP enabled successfully")
  end

  # POST /api/v1/auth/otp/validate
  def otp_validate
    return render_error("OTP is not set up", :bad_request) if current_user.otp_secret.blank?
    return render_error("Invalid OTP code", :unauthorized) unless valid_otp?(params[:otp])

    render_success({}, "OTP is valid")
  end

  # POST /api/v1/auth/otp/disable
  def otp_disable
    current_user.update!(otp_secret: nil, is_otp_enabled: false)
    render_success({}, "OTP disabled successfully")
  end

  private

  def valid_otp?(code)
    code.present? && ROTP::TOTP.new(current_user.otp_secret).verify(code.to_s, drift_behind: 30, drift_ahead: 30).present?
  end

  def register_params
    params.permit(:username, :first_name, :last_name, :email, :phone, :password, :password_confirmation,
                  :date_of_birth, :gender, :nationality)
  end
end

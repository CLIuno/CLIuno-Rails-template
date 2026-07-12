class ApplicationController < ActionController::API
  private

  def authenticate_user!
    token = extract_token
    return render_unauthorized("Missing token") unless token
    return render_unauthorized("Token has been invalidated") if BlacklistedToken.exists?(token: token)

    decoded = JwtService.decode(token)
    return render_unauthorized("Invalid or expired token") unless decoded

    @current_user = User.active.find_by(id: decoded[:user_id])
    render_unauthorized("User not found") unless @current_user
  end

  def authenticate_admin!
    authenticate_user!
    return if performed?

    render_forbidden("Admin access required") unless @current_user&.admin?
  end

  def current_user
    @current_user
  end

  def extract_token
    header = request.headers["Authorization"]
    header&.split(" ")&.last
  end

  def render_unauthorized(message = "Unauthorized")
    render json: { status: "error", message: message }, status: :unauthorized
  end

  def render_forbidden(message = "Forbidden")
    render json: { status: "error", message: message }, status: :forbidden
  end

  def render_not_found(message = "Not found")
    render json: { status: "error", message: message }, status: :not_found
  end

  def render_success(data = {}, message = "Success", status = :ok)
    render json: { status: "success", message: message, data: data }, status: status
  end

  def render_error(message = "Error", status = :unprocessable_entity, errors = nil)
    response = { status: "error", message: message }
    response[:errors] = errors if errors
    render json: response, status: status
  end
end

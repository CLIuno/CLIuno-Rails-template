class Api::V1::RolesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_role, only: %i[show update destroy users]

  # GET /api/v1/roles
  def index
    roles = Role.all
    render_success({ roles: roles })
  end

  # GET /api/v1/roles/:id
  def show
    render_success({ role: @role })
  end

  # POST /api/v1/roles
  def create
    role = Role.new(role_params)

    if role.save
      render_success({ role: role }, "Role created successfully", :created)
    else
      render_error("Role creation failed", :unprocessable_entity, role.errors.full_messages)
    end
  end

  # PATCH /api/v1/roles/:id
  def update
    if @role.update(role_params)
      render_success({ role: @role }, "Role updated successfully")
    else
      render_error("Role update failed", :unprocessable_entity, @role.errors.full_messages)
    end
  end

  # DELETE /api/v1/roles/:id
  def destroy
    @role.destroy!
    render_success({}, "Role deleted successfully")
  end

  # GET /api/v1/roles/:role_id/users
  def users
    users = @role.users.active
    render_success({ users: users })
  end

  private

  def set_role
    @role = Role.find_by(id: params[:id] || params[:role_id])
    render_not_found("Role not found") unless @role
  end

  def role_params
    params.permit(:name)
  end
end

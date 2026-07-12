class Api::V1::TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[show update destroy toggle]

  # GET /api/v1/todos
  def index
    todos = Todo.includes(:user).order(created_at: :desc)
    render_success({ todos: todos.as_json(include: { user: { except: %i[password_digest refresh_token] } }) })
  end

  # GET /api/v1/todos/current-user
  def current_user_todos
    todos = current_user.todos.order(created_at: :desc)
    render_success({ todos: todos })
  end

  # GET /api/v1/todos/:id
  def show
    render_success({ todo: @todo.as_json(include: { user: { except: %i[password_digest refresh_token] } }) })
  end

  # POST /api/v1/todos
  def create
    todo = current_user.todos.build(todo_params)

    if todo.save
      render_success({ todo: todo }, "Todo created successfully", :created)
    else
      render_error("Todo creation failed", :unprocessable_entity, todo.errors.full_messages)
    end
  end

  # PATCH /api/v1/todos/:id
  def update
    if @todo.update(todo_params)
      render_success({ todo: @todo }, "Todo updated successfully")
    else
      render_error("Todo update failed", :unprocessable_entity, @todo.errors.full_messages)
    end
  end

  # DELETE /api/v1/todos/:id
  def destroy
    @todo.destroy!
    render_success({}, "Todo deleted successfully")
  end

  # PATCH /api/v1/todos/:id/toggle
  def toggle
    @todo.update!(is_completed: !@todo.is_completed)
    render_success({ todo: @todo }, "Todo toggled successfully")
  end

  private

  def set_todo
    @todo = Todo.find_by(id: params[:id])
    render_not_found("Todo not found") unless @todo
  end

  def todo_params
    params.permit(:title, :description, :is_completed)
  end
end

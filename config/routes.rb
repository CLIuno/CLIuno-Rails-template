Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Auth
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"
      post "auth/logout", to: "auth#logout"
      post "auth/refresh-token", to: "auth#refresh_token"
      post "auth/check-token", to: "auth#check_token"
      post "auth/change-password", to: "auth#change_password"
      post "auth/forgot-password", to: "auth#forgot_password"
      post "auth/reset-password", to: "auth#reset_password"
      post "auth/send-verify-email", to: "auth#send_verify_email"
      post "auth/verify-email", to: "auth#verify_email"
      post "auth/otp/generate", to: "auth#otp_generate"
      post "auth/otp/verify", to: "auth#otp_verify"
      post "auth/otp/validate", to: "auth#otp_validate"
      post "auth/otp/disable", to: "auth#otp_disable"

      # Users
      get "users/current", to: "users#current"
      patch "users/current", to: "users#update_current"
      delete "users/current", to: "users#delete_current"
      get "users/username/:username", to: "users#by_username"
      get "users/:user_id/posts", to: "users#posts"
      get "users/:user_id/roles", to: "users#role"
      get "users", to: "users#index"
      get "users/:id", to: "users#show"
      patch "users/:id", to: "users#update_user"
      delete "users/:id", to: "users#delete_user"

      # Roles
      resources :roles, only: %i[index show create update destroy] do
        get "users", on: :member
      end

      # Posts
      get "posts/current-user", to: "posts#current_user_posts"
      resources :posts, only: %i[index show create update destroy] do
        member do
          get "user", to: "posts#user"
        end
        resources :comments, only: %i[index create update destroy]
      end

      # Todos
      get "todos/current-user", to: "todos#current_user_todos"
      resources :todos, only: %i[index show create update destroy] do
        patch "toggle", on: :member
      end

      # Follows
      post "follows/:user_id/follow", to: "follows#follow"
      delete "follows/:user_id/follow", to: "follows#unfollow"
      get "follows/:user_id/followers", to: "follows#followers"
      get "follows/:user_id/following", to: "follows#following"
      get "follows/:user_id/is-following", to: "follows#is_following"
    end
  end
end

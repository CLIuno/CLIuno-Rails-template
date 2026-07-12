# CLIuno Rails template

Rails 8 API serving the CLIuno contract with JWT auth (refresh, reset, email
verification, OTP via rotp) under `/api/v1`: users, todos, posts+comments, follows, roles.

## Commands

```bash
bundle install && bin/rails db:prepare   # setup (runs migrations + db/seeds.rb)
bin/rails server                         # dev server
bin/rails test                           # minitest — keep it green
bundle exec rubocop                      # lint (rails-omakase)
```

## Structure

`config/routes.rb` (namespace `api/v1`) → `app/controllers/api/v1/` →
`app/models/`; `app/services/jwt_service.rb` encodes access/refresh JWTs;
`render_success(data, message)` / `render_error` build the shared envelope;
`authenticate_user!` / `authenticate_admin!` are the guards.

## Contract rules this codebase follows

- Responses: `{status, message, data}` with the exact keys frontends destructure
  (`data.users/user/todos/todo/posts/post/followers/following/isFollowing`,
  login `data.token` + `data.refresh_token`).
- Requests accept camelCase (`usernameOrEmail`, `refreshToken`, `oldPassword`/`newPassword`,
  `otp`) alongside snake_case — keep both when adding params.
- One-time tokens live on users (`reset_password_token`, `verify_token`); reset/verify
  look users up **by token**.
- `db/seeds.rb` creates the roles + a default admin; registration falls back to the
  `user` role.
- `GET /users` is authenticated (not admin); `PATCH/DELETE /users/:id` are admin.
- Follows routes: `/follows/:user_id/{follow,followers,following,is-following}`.

## Conventions

rubocop-rails-omakase; conventional commits; controller tests in
`test/controllers/api/v1/` assert contract shapes — update them with any envelope change.

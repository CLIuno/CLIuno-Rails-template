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

## AI agents (Claude Code and friends)

These commands need **cliuno 2.2 or newer** (`npx cliuno@^2.2` fetches it).

- **Check the CLIuno skills first**: `npx cliuno@^2.2 skills status` — if any is
  `missing`/`outdated`, run `npx cliuno@^2.2 skills install` (adds `.claude/skills/cliuno-*`:
  the generator workflow, the scaffold guide, and the shared REST contract).
- **Generate resources, don't hand-write them**:
  `npx cliuno@^2.2 make:resource Product --fields name:string,price:number,inStock:boolean`
  creates `app/models/product.rb`, `db/migrate/<timestamp>_create_products.rb`, `app/controllers/api/v1/products_controller.rb`, `test/fixtures/products.yml`, `test/controllers/api/v1/products_controller_test.rb`, `test/models/product_test.rb` and registers it in `config/routes.rb`, `app/models/user.rb`, following this
  template's conventions and the `{status, message, data}` contract. `--dry-run` previews,
  re-running never duplicates registrations, `--force` overwrites.
- Single pieces: `make:model` (→ `bin/rails generate model`), `make:controller` (→ `bin/rails generate controller`), `make:migration` (→ `bin/rails generate migration`), `make:test`. `npx cliuno@^2.2 make` lists them.
- Then edit fields/business logic only, and run the gates above.

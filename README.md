# Cliuno Ruby on rails template

<img src="./public/logo.png" style="width: 300px; height: 300px; padding-bottom: 30px;" alt="logo">

## Installation

if you want to run the project locally make sure you have installed Ruby and Bundler.
to install Ruby go to [ruby](https://www.ruby-lang.org/en/downloads/)

if you want to run the project using docker make sure you have installed docker.

to install docker go to [docker](https://docs.docker.com/get-docker/)

to run the project using docker run the following command

```bash
docker compose -d up
```

or pull the image from docker hub

```bash
docker pull iru44/rails-template
```

make sure you pull the database image from docker hub as well

then run the following command

```bash
docker run -p 3000:3000 iru44/rails-template
```

if you want to run the project using kubernetes make sure you have installed minikube.

to install minikube go to [minikube](https://minikube.sigs.k8s.io/docs/start/)
to install kubectl go to [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Clone the repository

```bash
git clone https://github.com/CLIuno/CLIuno-Rails-template.git
```

then run the following command

```bash
bundle install
```

## Usage

after installing the dependencies you can run the project using the following command to migrate the database

```bash
bin/rails db:migrate
bin/rails db:seed
```

then you run the project using the following command

```bash
bin/rails server
```

## Features

list of features that already implemented:

| Status             | Feature                       |
| ------------------ | ----------------------------- |
| :white_check_mark: | Auth routes                   |
| :white_check_mark: | User routes                   |
| :white_check_mark: | Role routes                   |
| :white_check_mark: | Post routes                   |
| :white_check_mark: | Comment routes                |
| :white_check_mark: | Todo routes                   |
| :white_check_mark: | Follow routes                 |
| :white_check_mark: | CI/CD with GitHub Actions     |
| :white_check_mark: | Logging                       |
| :white_check_mark: | Dockerize                     |
| [ ]                | Kubernetes                    |
| :white_check_mark: | Soft delete                   |
| :white_check_mark: | SQLite database               |
| :white_check_mark: | JWT authentication            |
| :white_check_mark: | Token blacklisting            |
| :white_check_mark: | CORS enabled                  |
| :white_check_mark: | Unit tests                    |
| [ ]                | Fully documentation           |
| :white_check_mark: | Postman collection just basic |

## Premium features

You will get more features if you buy the full version and you can use it for commercial purposes (contact me for more information)

| Status             | Feature                      |
| ------------------ | ---------------------------- |
| :white_check_mark: | Vote routes                  |
| :white_check_mark: | Comment routes               |
| :white_check_mark: | Permission routes            |
| :white_check_mark: | Reacion routes               |
| :white_check_mark: | Payment routes               |
| :white_check_mark: | Notification routes          |
| :white_check_mark: | Pagination                   |
| :white_check_mark: | Redis cache                  |
| :white_check_mark: | File upload                  |
| :white_check_mark: | Fully unit test              |

## list of endpoints

### Auth

| Status             | Endpoint Description | Method | Path                              |
| ------------------ | -------------------- | ------ | --------------------------------- |
| :white_check_mark: | Register             | POST   | `/api/v1/auth/register`           |
| :white_check_mark: | Login                | POST   | `/api/v1/auth/login`              |
| :white_check_mark: | Logout               | POST   | `/api/v1/auth/logout`             |
| :white_check_mark: | Refresh Token        | POST   | `/api/v1/auth/refresh-token`      |
| :white_check_mark: | Check Token          | POST   | `/api/v1/auth/check-token`        |
| :white_check_mark: | Change Password      | POST   | `/api/v1/auth/change-password`    |

### Users

| Status             | Endpoint Description | Method | Path                                    |
| ------------------ | -------------------- | ------ | --------------------------------------- |
| :white_check_mark: | Get Current User     | GET    | `/api/v1/users/current`                 |
| :white_check_mark: | Update Current User  | PATCH  | `/api/v1/users/current`                 |
| :white_check_mark: | Delete Current User  | DELETE | `/api/v1/users/current`                 |
| :white_check_mark: | Get By Username      | GET    | `/api/v1/users/username/:username`      |
| :white_check_mark: | Get User Posts       | GET    | `/api/v1/users/posts`                   |
| :white_check_mark: | Get User Role        | GET    | `/api/v1/users/role`                    |
| :white_check_mark: | List All Users       | GET    | `/api/v1/users`                         |
| :white_check_mark: | Get User By ID       | GET    | `/api/v1/users/:id`                     |
| :white_check_mark: | Admin Update User    | PATCH  | `/api/v1/users/:id`                     |
| :white_check_mark: | Admin Delete User    | DELETE | `/api/v1/users/:id`                     |

### Roles

| Status             | Endpoint Description | Method | Path                          |
| ------------------ | -------------------- | ------ | ----------------------------- |
| :white_check_mark: | List Roles           | GET    | `/api/v1/roles`               |
| :white_check_mark: | Create Role          | POST   | `/api/v1/roles`               |
| :white_check_mark: | Get Role             | GET    | `/api/v1/roles/:id`           |
| :white_check_mark: | Update Role          | PATCH  | `/api/v1/roles/:id`           |
| :white_check_mark: | Delete Role          | DELETE | `/api/v1/roles/:id`           |
| :white_check_mark: | Users By Role        | GET    | `/api/v1/roles/:id/users`     |

### Posts

| Status             | Endpoint Description  | Method | Path                                       |
| ------------------ | --------------------- | ------ | ------------------------------------------ |
| :white_check_mark: | List Posts             | GET    | `/api/v1/posts`                            |
| :white_check_mark: | Current User Posts     | GET    | `/api/v1/posts/current-user`               |
| :white_check_mark: | Create Post            | POST   | `/api/v1/posts`                            |
| :white_check_mark: | Get Post               | GET    | `/api/v1/posts/:id`                        |
| :white_check_mark: | Update Post            | PATCH  | `/api/v1/posts/:id`                        |
| :white_check_mark: | Delete Post            | DELETE | `/api/v1/posts/:id`                        |
| :white_check_mark: | Get Post Author        | GET    | `/api/v1/posts/:id/user`                   |

### Comments

| Status             | Endpoint Description | Method | Path                                             |
| ------------------ | -------------------- | ------ | ------------------------------------------------ |
| :white_check_mark: | List Comments        | GET    | `/api/v1/posts/:post_id/comments`                |
| :white_check_mark: | Create Comment       | POST   | `/api/v1/posts/:post_id/comments`                |
| :white_check_mark: | Update Comment       | PATCH  | `/api/v1/posts/:post_id/comments/:id`            |
| :white_check_mark: | Delete Comment       | DELETE | `/api/v1/posts/:post_id/comments/:id`            |

### Todos

| Status             | Endpoint Description | Method | Path                              |
| ------------------ | -------------------- | ------ | --------------------------------- |
| :white_check_mark: | List Todos           | GET    | `/api/v1/todos`                   |
| :white_check_mark: | Current User Todos   | GET    | `/api/v1/todos/current-user`      |
| :white_check_mark: | Create Todo          | POST   | `/api/v1/todos`                   |
| :white_check_mark: | Get Todo             | GET    | `/api/v1/todos/:id`               |
| :white_check_mark: | Update Todo          | PATCH  | `/api/v1/todos/:id`               |
| :white_check_mark: | Delete Todo          | DELETE | `/api/v1/todos/:id`               |
| :white_check_mark: | Toggle Todo          | PATCH  | `/api/v1/todos/:id/toggle`        |

### Follows

| Status             | Endpoint Description | Method | Path                                       |
| ------------------ | -------------------- | ------ | ------------------------------------------ |
| :white_check_mark: | Follow User          | POST   | `/api/v1/follows/:user_id/follow`          |
| :white_check_mark: | Unfollow User        | DELETE | `/api/v1/follows/:user_id/follow`          |
| :white_check_mark: | Get Followers        | GET    | `/api/v1/follows/:user_id/followers`       |
| :white_check_mark: | Get Following        | GET    | `/api/v1/follows/:user_id/following`       |
| :white_check_mark: | Is Following         | GET    | `/api/v1/follows/:user_id/is-following`    |
| :white_check_mark: | Database Factory             |
| :white_check_mark: | Make use of Enums            |
| :white_check_mark: | GraphQL (Optional)           |
| :white_check_mark: | Postman collection extra     |
| :white_check_mark: | Postgres database or MongoDB |

## list of endpoints

### Auth

| Status             | Endpoint Description    | Method | Path                             |
| ------------------ | ----------------------- | ------ | -------------------------------- |
| :white_check_mark: | Login                   | POST   | `/api/v1/auth/login`             |
| [ ]                | Register                | POST   | `/api/v1/auth/register`          |
| [ ]                | Logout                  | POST   | `/api/v1/auth/logout`            |
| :white_check_mark: | Reset Password          | POST   | `/api/v1/auth/reset-password`    |
| :white_check_mark: | Forgot Password         | POST   | `/api/v1/auth/forgot-password`   |
| :white_check_mark: | Change Password         | POST   | `/api/v1/auth/change-password`   |
| :white_check_mark: | Send Verification Email | POST   | `/api/v1/auth/send-verify-email` |
| :white_check_mark: | Verify Email            | POST   | `/api/v1/auth/verify-email`      |
| [ ]                | Check Token             | POST   | `/api/v1/auth/check-token`       |
| [ ]                | Refresh Token           | POST   | `/api/v1/auth/refresh-token`     |
| :white_check_mark: | Verify OTP              | POST   | `/api/v1/auth/otp/verify`        |
| :white_check_mark: | Disable OTP             | POST   | `/api/v1/auth/otp/disable`       |
| :white_check_mark: | Validate OTP            | POST   | `/api/v1/auth/otp/validate`      |
| :white_check_mark: | Generate OTP            | POST   | `/api/v1/auth/otp/generate`      |

### Users

| Status | Endpoint Description    | Method | Path                                 |
| ------ | ----------------------- | ------ | ------------------------------------ |
| [ ]    | Get all current user    | GET    | `/api/v1/users/current`              |
| [ ]    | Get user by username    | GET    | `/api/v1/users/username/:username`   |
| [ ]    | Get all users           | GET    | `/api/v1/users`                      |
| [ ]    | Get a user by ID        | GET    | `/api/v1/users/:id`                  |
| [ ]    | Update user by ID       | PATCH  | `/api/v1/users/:id`                  |
| [ ]    | Delete user by ID       | DELETE | `/api/v1/users/:id`                  |
| [ ]    | Get permissions by user | GET    | `/api/v1/users/:user_id/permissions` |
| [ ]    | Get posts by user       | GET    | `/api/v1/users/:user_id/posts`       |
| [ ]    | Get roles by user       | GET    | `/api/v1/users/:user_id/roles`       |

### Roles

| Status | Endpoint Description    | Method | Path                                 |
| ------ | ----------------------- | ------ | ------------------------------------ |
| [ ]    | Get all roles           | GET    | `/api/v1/roles`                      |
| [ ]    | Get role by ID          | GET    | `/api/v1/roles/:id`                  |
| [ ]    | Create a role           | POST   | `/api/v1/roles`                      |
| [ ]    | Update role by ID       | PATCH  | `/api/v1/roles/:id`                  |
| [ ]    | Delete role by ID       | DELETE | `/api/v1/roles/:id`                  |
| [ ]    | Get permissions by role | GET    | `/api/v1/roles/:role_id/permissions` |
| [ ]    | Get users by role       | GET    | `/api/v1/roles/:role_id/users`       |

### Posts

| Status | Endpoint Description       | Method | Path                          |
| ------ | -------------------------- | ------ | ----------------------------- |
| [ ]    | Get all current user posts | GET    | `/api/v1/posts/current-user`  |
| [ ]    | Get all posts              | GET    | `/api/v1/posts`               |
| [ ]    | Get post by ID             | GET    | `/api/v1/posts/:id`           |
| [ ]    | Create a post              | POST   | `/api/v1/posts`               |
| [ ]    | Update post by ID          | PATCH  | `/api/v1/posts/:id`           |
| [ ]    | Delete post by ID          | DELETE | `/api/v1/posts/:id`           |
| [ ]    | Get users by post          | GET    | `/api/v1/posts/:post_id/user` |

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def auth_token_for(user)
      JwtService.encode(user_id: user.id)
    end

    def auth_headers_for(user)
      { "Authorization" => "Bearer #{auth_token_for(user)}" }
    end
  end
end

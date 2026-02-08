ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    # Add this helper method here
    def sign_in_as(account)
      # Replace 'login_url' with your actual sign-in path (maybe sessions_url or sign_in_url)
      post login_url, params: { email: account.email, password: 'password' }
    end
  end
end
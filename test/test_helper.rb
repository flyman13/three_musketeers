ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    # Додай цей метод сюди
    def sign_in_as(account)
      # Заміни 'login_url' на ваш реальний шлях (можливо sessions_url або sign_in_url)
      post login_url, params: { email: account.email, password: 'password' }
    end
  end
end
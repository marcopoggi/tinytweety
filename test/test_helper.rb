ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options = {})
    password = options[:password] || "password"
    remember_me = options[:remember_me] || "1"

    if is_integration_test?
      #login with POST request
      post login_path, params: { session: { email: user.email,
                                           password: password,
                                  remember_me: remember_me }
    else
      #assign id mannualy
      session[:user_id] = user.id
    end
  end

  private

  def is_integration_test?
    defined?(post)
  end
end

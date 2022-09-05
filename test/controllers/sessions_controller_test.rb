require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get the 'new' view when /login is requested" do
    get login_path
    assert_response :success
  end
end

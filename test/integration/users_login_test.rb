require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid credentials" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", password: "" } } #invalid
    assert_template "sessions/new"
    assert_not flash.empty?, "flash hash should be not empty"
    get root_path
    assert flash.empty?, "flash hash should be empty"
  end
end

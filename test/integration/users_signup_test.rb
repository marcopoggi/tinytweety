require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    @invalid_user = { name: "",
                      email: "user@invalid",
                      password: "foo",
                      password_confirmation: "bar" }

    @valid_user = { name: "example user",
                    email: "user@valid.com",
                    password: "pass1234",
                    password_confirmation: "pass1234" }

    @user_to_log_in = users(:anonymus)
  end

  test "invalid signup information" do
    get signup_path #GET /signup

    assert_template "users/new"

    assert_no_difference "User.count" do
      post users_path, params: { user: @invalid_user }
    end

    assert_template "users/new"
    #message errors
    assert_select "span.sign-error"
  end

  test "valid signup information" do
    get signup_path #GET /signup

    assert_template "users/new"

    assert_difference "User.count", 1 do
      post users_path,
           params: { user: @valid_user }
      assert_response :redirect
      follow_redirect!
    end

    assert_template "users/show"
    assert is_logged_in?
    assert_select "div.alert-success>span", text: "🙋‍♀️ Welcome to TinyTweety"
    assert_select "div.alert-success>button.popup-close", text: "❌"
  end

  test "should be close session if want register" do
    log_in_as(@user_to_log_in)
    get signup_path
    assert_redirected_to root_path
    assert_not flash.empty?
  end
end

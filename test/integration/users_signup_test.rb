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

    assert_select "div.alert-success", text: "🙋‍♀️ Welcome to TinyTweety"
  end
end

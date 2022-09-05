require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path #GET /signup

    assert_template "users/new"

    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    end

    assert_template "users/new"
  end

  test "valid signup information" do
    get signup_path #GET /signup

    assert_template "users/new"

    assert_difference "User.count", 1 do
      post users_path,
           params: { user: { name: "example user",
                            email: "user@valid.com",
                            password: "pass1234",
                            password_confirmation: "pass1234" } }
      assert_response :redirect
      follow_redirect!
    end

    assert_template "users/show"
  end
end

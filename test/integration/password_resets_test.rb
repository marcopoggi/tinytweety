require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:anonymus)
  end

  test "password reset" do
    get new_password_reset_path
    assert_template "password_resets/new"
    #invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template "password_resets/new"
    #valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_not flash.empty? #sent notification
    assert_redirected_to root_url

    #password reset form
    #-------------------
    user = assigns(:user)
    #wrong email in params
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    #user not activated
    user.toggle!(:activated) #set attr activated = false
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated) #set attr activated = true

    #correct email but invalid token
    get edit_password_reset_path("222token222", email: user.email)
    assert_redirected_to root_url

    #correct email & correct token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email

    #invalid new password
    patch password_reset_path(user.reset_token),
          params: {
            email: user.email,
            user: { password: "",
                    password_confirmation: "" },
          }
    assert_select "span.sign-error"
    #all data valid
    patch password_reset_path(user.reset_token),
          params: {
            email: user.email,
            user: { password: "correct123",
                    password_confirmation: "correct123" },
          }
    assert is_logged_in?
    assert_not flash.empty? #password changed notification
    assert_redirected_to user # go to profile
  end
end

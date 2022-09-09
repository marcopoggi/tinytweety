require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:anonymus)
    @random_user = users(:random)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "user must be logged in to edit" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "user must be logged in to update" do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
    assert_response 302
  end

  test "I should be able to edit only my information" do
    log_in_as(@random_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "I should be able to update only my information" do
    log_in_as(@random_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
end

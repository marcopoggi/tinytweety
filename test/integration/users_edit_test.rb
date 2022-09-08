require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:anonymus)

    @invalid_user_data = { user: { name: "", email: "invalid@email",
                                  password: "faa", password_confirmation: "baa" } }

    @valid_user_data_without_password = { user: { name: "anonymus edited", email: "valid@gmail.com",
                                                 password: "", password_confirmation: "" } }

    @valid_user_data = { user: { name: "anonymus edited", email: "valid@gmail.com",
                                password: "passwordupdated", password_confirmation: "passwordupdated" } }
  end

  test "account edition failed or invalid" do
    #create a session
    log_in_as(@user)

    get settings_account_user_path(@user)
    assert_template "users/edit"

    patch user_path(@user), params: @invalid_user_data
    assert_template "users/edit"
  end

  test "account edition successful(name and email)" do
    #create a session
    log_in_as(@user)

    get settings_account_user_path(@user)
    assert_template "users/edit"

    patch user_path(@user), params: @valid_user_data_without_password

    #successful edition
    assert_not flash.empty?, "> Flash should be contain a 'Profile updated' message"
    assert_redirected_to @user
    @user.reload

    name = @valid_user_data_without_password[:user][:name]
    email = @valid_user_data_without_password[:user][:email]

    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  test "account edition only email" do
    #create a session
    log_in_as(@user)

    get settings_account_user_path(@user)
    assert_template "users/edit"

    @valid_user_data_without_password[:user][:name] = ""

    patch user_path(@user), params: @valid_user_data_without_password

    assert_not flash.empty?, "> Flash should be contain a 'Profile updated' message"
    assert_redirected_to @user
    @user.reload

    email = @valid_user_data_without_password[:user][:email]

    assert_equal @user.email, email
  end

  test "account edition only name" do
    #create a session
    log_in_as(@user)

    get settings_account_user_path(@user)
    assert_template "users/edit"

    @valid_user_data_without_password[:user][:email] = ""

    patch user_path(@user), params: @valid_user_data_without_password

    assert_not flash.empty?, "> Flash should be contain a 'Profile updated' message"
    assert_redirected_to @user
    @user.reload

    name = @valid_user_data_without_password[:user][:name]

    assert_equal @user.name, name
  end

  test "account edition successful(name and email and password)" do
    #create a session
    log_in_as(@user)

    get settings_account_user_path(@user)
    assert_template "users/edit"

    patch user_path(@user), params: @valid_user_data

    #successful edition
    assert_not flash.empty?, "> Flash should be contain a 'Profile updated' message"
    assert_redirected_to @user
    @user.reload

    name = @valid_user_data[:user][:name]
    email = @valid_user_data[:user][:email]
    password = "passwordupdated"

    assert_equal @user.name, name
    assert_equal @user.email, email
    assert @user.authenticate(password)
  end

  test "successful edition with friendly redirection" do
    get settings_account_user_path(@user)
    log_in_as(@user)
    assert_redirected_to settings_account_user_path(@user)

    patch user_path(@user), params: @valid_user_data
    assert_not flash.empty?
    assert_redirected_to @user
  end
end

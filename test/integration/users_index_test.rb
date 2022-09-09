require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:anonymus)
  end

  test "index should be include pagination" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select "nav.pagination"

    users = User.order(:name).page(1).per(15)

    users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
end

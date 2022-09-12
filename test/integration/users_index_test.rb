require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:anonymus)
    @admin = users(:random)
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

  test "index as admin should be include pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "nav.pagination"

    users = User.order(:name).page(1).per(15)

    users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      if user != @admin
        assert_select "a[href=?]", user_path(user)
        assert_select "div.options>a>img:match('src',?)", /^\/assets\/delete-icon-[a-zA-Z0-9]*.png/
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@user)
    end
  end

  test "index as non-admin user" do
    log_in_as(@user)
    get users_path
    assert_select "div.options>a>img:match('src',?)", /^\/assets\/delete-icon-[a-zA-Z0-9]*.png/, count: 0
  end
end

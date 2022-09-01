require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "example name", email: "example@email.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "user name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "user email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "user name should not be too long (max 50)" do
    @user.name = "x" * 51
    assert_not @user.valid?
  end

  test "user email should not be too long (max 256)" do
    @user.email = "x" * 245 + "@example.com"
    assert_not @user.valid?
  end
end

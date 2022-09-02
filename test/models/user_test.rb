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

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@random.COM A_user-example@exam.ple.com user+other@random.cm]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should be rejected for invalid email addresses" do
    invalid_addresses = %w[user@example,com user.com user@example. @example.com user@exam+ple.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup #duplicate user instance with same attributes
    duplicate_user.email = @user.email.upcase

    @user.save
    
    assert_not duplicate_user.valid?
  end
end

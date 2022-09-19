require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "example name", email: "example@email.com",
                     password: "pass1234", password_confirmation: "pass1234")
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
    invalid_addresses = %w[user@example,com user.com user@example. @example.com user@exam+ple.com user@mail..com]

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

  test "email addresses should be saved as lower-case" do
    mixed_email = "eXamPle_EmaiL@GmaiL.CoM"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end

  test "password should be a min length(8)" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "associated posts should be destroyed" do
    @user.save
    @user.posts.create!(content: "text for trying destruction")
    assert_difference "Post.count", -1 do
      @user.destroy
    end
  end

  test "should follow & unfollow a user" do
    user_a = users(:anonymus)
    user_b = users(:random_c)

    assert_not user_a.following?(user_b)
    user_a.follow(user_b)
    assert user_a.following?(user_b)
    assert user_b.followers.include?(user_a)
    user_a.unfollow(user_b)
    assert_not user_a.following?(user_b)
  end

  test "my feed should contain the posts of the users I follow" do
    anonymus = users(:anonymus)
    random = users(:random)
    random_c = users(:random_c)

    #anonymus follow -> random
    random.posts.each do |post_following|
      assert anonymus.feed.include?(post_following)
    end

    #my own posts
    anonymus.posts.each do |my_post|
      assert anonymus.feed.include?(my_post)
    end

    #anonymus unfollow -> random_c
    random_c.posts.each do |post_unfollowed|
      assert_not anonymus.feed.include?(post_unfollowed)
    end
  end
end

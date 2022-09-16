require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user_a = users(:anonymus)
    @user_b = users(:random)
    @relationship = Relationship.new(follower_id: @user_a.id, followed_id: @user_b.id)
  end

  test "should be valid" do
    assert @relationship.valid?, "❌ The relationship is not valid"
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?, "❌ The relationship should not be valid without a follower_id"
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?, "❌ The relationship should not be valid without a followed_id"
  end
end

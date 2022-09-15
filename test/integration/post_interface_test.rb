require "test_helper"

class PostInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user_with_posts = users(:anonymus)
    log_in_as(@user_with_posts)
  end

  test "should be render my feed in home page" do
    get root_path
    feed = @user_with_posts.feed.take(3)
    feed.each do |post|
      assert_select "li#post-#{post.id}"
    end
  end

  test "should not be able to create an empty post" do
    get root_path
    assert_no_difference "Post.count" do
      post posts_path, params: { post: { content: "" } }
    end
  end

  test "must be able to create a valid post" do
    get root_path
    content = "lorem ipsum random text..."
    assert_difference "Post.count", 1 do
      post posts_path, params: { post: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test "can i delete my own posts" do
    get root_path
    feed = @user_with_posts.feed.take(3)
    feed.each do |post|
      assert_select "li>div.post-actions>a", text: "❌"
    end
  end

  test "links to deleted posts from other users should not be rendered" do
    get user_path(users(:random))
    assert_select 'a', text: "❌", count: 0
  end
end

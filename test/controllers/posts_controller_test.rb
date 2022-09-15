require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:tau_manifesto)
  end

  test "should redirect when trying to create without login" do
    assert_no_difference "Post.count" do
      post posts_url, params: { post: { content: "Lorem ipsum" } }
    end

    assert_redirected_to login_url
  end

  test "should redirect when trying to destroy without login" do
    assert_no_difference "Post.count" do
      delete post_url(@post)
    end

    assert_redirected_to login_url
  end
end

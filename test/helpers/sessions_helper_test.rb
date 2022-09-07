require "test_helper"

class SessionsHelperTest < ActionView::TestCase
    def setup
        @user = users(:anonymus)
        remember(@user)
    end

    test "current user method should be return a correct user when session is nil" do
        assert_equal @user, current_user
        assert logged_in?
    end

    test "current user method should be return nil when remember_digest is wrong" do
        @user.update_attribute(:remember_digest,User.digest(User.new_token))
        assert_nil current_user, "expected nil because the cookie is not signed correctly"
    end
end

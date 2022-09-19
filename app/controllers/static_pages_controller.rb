class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_posts = current_user.feed.page(params[:page]).per(15)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

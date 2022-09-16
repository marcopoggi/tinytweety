class PostsController < ApplicationController
  before_action(:logged_in_user, only: [:create, :destroy])
  before_action(:correct_user, only: :destroy)

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:info] = "✅ Post created"
      redirect_to root_path
    else
      @feed_posts = current_user.feed.take(3)
      render "static_pages/home", status: 400
    end
  end

  def destroy
    @post.destroy 
    flash[:info] = "✅ Post Deleted"
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    if @post.nil?
      flash[:info] = "⚠️ The post could not be deleted"
      redirect_to root_url
    end
  end
end

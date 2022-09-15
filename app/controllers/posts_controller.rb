class PostsController < ApplicationController
  before_action(:logged_in_user, only: [:create, :destroy])

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:info] = "✅ Post created"
      redirect_to root_path
    else
      render "static_pages/home", status: 400
    end
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end

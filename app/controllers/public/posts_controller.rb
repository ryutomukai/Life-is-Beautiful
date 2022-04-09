class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post.id)
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to user_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit(:image,:video,:title,:body)
  end

end

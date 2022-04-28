class Public::PostCommentsController < ApplicationController

  #アクセス制限
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id
    if @post_comment.save
    #通知
      @post.create_notification_post_comment!(current_user, @post_comment.id)
      redirect_to post_path(@post)
    else
      render "public/posts/show"
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to request.referer
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end

class Public::PostsController < ApplicationController

  before_action :search

  def new
    @post = Post.new
  end

  def search
    # params[:q]のqには検索フォームに入力した値が入る
    @q = Post.ransack(params[:q])
  end

  #投稿にいいねしたユーザー一覧
  def favorites
    @post = Post.find(params[:id])
    favorites = Favorite.where(post_id: @post.id).pluck(:user_id)
    @favorite_users = User.find(favorites)
  end

  def index
    @postall = Post.all
    #検索機能
    if !params[:q].nil? && params[:q][:title_or_body_cont] != "" && params[:q][:title_or_body_cont] != " " && params[:q][:title_or_body_or_cont] != "　"
      @posts = @q.result(distinct: true)
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id)
    else
      render "public/posts/new"
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_post_comments = @post.post_comments.page(params[:page]).per(5)
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

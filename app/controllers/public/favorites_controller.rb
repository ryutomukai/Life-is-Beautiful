class Public::FavoritesController < ApplicationController


  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    #通知
    @post.create_notification_favorite!(current_user)
    #非同期通信のため下記削除
    #redirect_to post_path(post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
    #非同期通信のため下記削除
    #redirect_to post_path(post)
  end

end

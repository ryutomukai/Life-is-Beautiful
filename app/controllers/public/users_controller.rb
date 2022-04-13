class Public::UsersController < ApplicationController

  before_action :search

  def search
    # params[:q]のqには検索フォームに入力した値が入る
    @q = User.ransack(params[:q])
  end

  def index
    @userall = User.all
    #検索機能

    if !params[:q].nil? && params[:q][:name_cont] != "" && params[:q][:name_cont] != " " && params[:q][:name_cont] != "　"
      @users = @q.result(distinct: true)
    end
  end

  def show
    @user = current_user
    @posts = @user.posts
  end

  def edit
    @user = current_user
  end

  def update
   @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "successfully"
    else
      render "edit" , notice: "failure"
    end
  end

  def unsubscribe
  end

  def withdrawal
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = '退会処理を実行いたしました'
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:name,:email,:introduction,:phone_number,:profile_image)
  end

end

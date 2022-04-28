class Public::UsersController < ApplicationController

  #アクセス制限
  before_action :authenticate_user!

  #ゲストユーザーの権限制限
  before_action :ensure_guest_user, only: [:edit, :unsubscribe, :withdrawal]
  #検索機能
  before_action :search

  #検索機能
  def search
    # params[:q]のqには検索フォームに入力した値が入る
    @q = User.ransack(params[:q])
  end

  #ユーザーがいいねした投稿一覧
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id:  @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  def index
    @userall = User.all.page(params[:page]).per(10)
    #検索機能
    if !params[:q].nil? && params[:q][:name_cont] != "" && params[:q][:name_cont] != " " && params[:q][:name_cont] != "　"
      @users = @q.result(distinct: true)
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
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

  #物理削除
  def destroy
      user = current_user
      user.destroy
      flash[:notice] = '退会しました'
      redirect_to :root #削除に成功すればrootページに戻る
  end

  #論理削除
  # def withdrawal
  #   @user = current_user
  #   @user.update(is_deleted: true)
  #   reset_session
  #   flash[:notice] = '退会処理を実行いたしました'
  #   redirect_to root_path
  # end

  def user_params
    params.require(:user).permit(:name,:email,:introduction,:phone_number,:profile_image)
  end


  private
    #ゲストユーザー
    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.name == "ゲストユーザー"
        redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
      end
    #
    end

end

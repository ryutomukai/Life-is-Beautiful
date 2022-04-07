class Public::UsersController < ApplicationController
  def index
  end

  def show
    
  end

  def edit
  end

  def withdrawal
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = '退会処理を実行いたしました'
    redirect_to root_path
  end

end

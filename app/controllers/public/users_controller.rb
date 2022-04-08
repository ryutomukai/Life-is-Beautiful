class Public::UsersController < ApplicationController
  def index
  end

  def show
    @user = current_user
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
    params.require(:user).permit(:name,:email,:introduction,:phone_number)
  end

end

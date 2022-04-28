class Public::NotificationsController < ApplicationController

  #アクセス制限
  before_action :authenticate_user!

  #通知一覧
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

end
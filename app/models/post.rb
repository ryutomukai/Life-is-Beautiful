class Post < ApplicationRecord

  has_one_attached :image
  has_one_attached :video

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  #投稿ファイル表示
  def get_file(width,height)
    if video.attached?
      video
    else image.attached?
      image
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #通知作成メソッド
  def create_notification_favorite!(current_user)
    #既にいいねされているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? ", current_user.id, user_id, id, "favorite"])
    #いいねさていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: "favorite"
      )
      #自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save. if notification.vaild?
    end
  end
end
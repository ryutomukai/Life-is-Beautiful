class Post < ApplicationRecord

  #投稿用モデル

  has_one_attached :image
  has_one_attached :video

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  #バリデーション
  validates :title, presence: true
  validates :body, presence: true
  #投稿時画像か動画ファイル必須(↓最下部メソッド設定)
  validate :required_either_image_or_video

  #投稿ファイル表示
  def get_file(width,height)
    if video.attached?
      video
    else image.attached?
      image
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  #いいね機能
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #通知作成メソッド(いいね)
  def create_notification_favorite!(current_user)
    #既にいいねされているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, "favorite"])
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
      notification.save if notification.valid?
    end
  end

  #通知作成メソッド(コメント)
  def create_notification_post_comment!(current_user, post_comment_id)
    #自分以外にコメントしている人を全て取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    #まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_post_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_post_comment!(current_user, post_comment_id, visited_id)
    #複数回コメントすることが考えられるため、一つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: "post_comment"
    )
    #自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save
  end




  private

  #カスタムバリデーション用メソッド(投稿時画像か動画ファイル必須)
  def required_either_image_or_video
    # 演算子 ^ で排他的論理和（XOR）にしています
    # emailかphoneのどちらかの値があれば true
    # email、phoneどちらも入力されている場合や入力されていない場合は false
    return if image.present? ^ video.present?

    errors.add(:base, '画像または動画のどちらか一方を添付してください')
  end

end
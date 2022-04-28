class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  #バリデーション
  validates :comment, presence: true
  validate :ng_word

  #コメント制限メソッド(誹謗中傷ワードが含まれている場合コメント投稿不可)
  def ng_word
    limits = Limit.all
    limits.each do |limit|
      if self.comment.include?(limit.word)
        errors.add(:comment, "は制限ワードが含まれています")
      end
    end
  end

  def create_notification_post_comment!(current_user, post_comment_id)
    #自分以外にコメントしている人を全て取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save.notification_post_comment!(current_user, post_comment_id, temp_id["user_id"])
    end
    #まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_post_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_post_comment!(current_user, post_comment_id, visited_id )
    #コメントは複数回することが考えられるため、一つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: "post_comment"
    )
    #自分の投稿に対するコメントの場合は、通地済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end

class Notification < ApplicationRecord

  #通知機能用モデル

  #デフォルト並び順を作成日時の降順指定
  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :post_comment, optional: true

  belongs_to :visitor, class_name: "User", foreign_key: "visitor_id", optional: true
  belongs_to :visited, class_name: "User", foreign_key: "visited_id", optional: true

end

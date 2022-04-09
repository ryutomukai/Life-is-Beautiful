class Post < ApplicationRecord

  has_one_attached :image
  has_one_attached :video

  belongs_to :user
  has_many :post_comments, dependent: :destroy

  #投稿ファイル表示
  def get_file(width,height)
    if video.attached?
      video
    else image.attached?
      image
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
end

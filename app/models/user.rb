class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :profile_image

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #フォロー一覧画面用
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #通知機能
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  #ゲストログイン
  def self.guest
    find_or_create_by!(name: 'ゲストユーザー' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end


  def follow(user_id)
      relationships.create(followed_id: user_id)
  end
  def unfollow(user_id)
      relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
      followings.include?(user)
  end



  #プロフィール画像表示
  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
      profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def active_for_authentication?
    super && (is_deleted == false)
  end

end

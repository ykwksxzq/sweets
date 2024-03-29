class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 100 }


  # mypage用
  has_one_attached :profile_image

  def get_profile_image(width,height)
   unless profile_image.attached?
     file_path = Rails.root.join('app/assets/images/no_image.jpg')
     profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
   end
     profile_image.variant(resize_to_limit: [width, height]).processed
  end

  GUEST_MEMBER_EMAIL = "guest@example.com"

  #ゲストログイン用
  def self.guest
    find_or_create_by!(email: GUEST_MEMBER_EMAIL ) do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    user.name = "ゲスト"
    end
  end

  def guest_user?
    email == GUEST_MEMBER_EMAIL
  end

  def owns?(other_user)
    self == other_user
  end

  # current_user 且つ guest_user でなかったら
  # if @user == current_user && !current_user.guest_user?

  def matches_current_user?(other_user)
    self == other_user && !other_user.guest_user?
  end

  # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed
  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower

  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end

end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  
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
     profile_image
  end

  #ゲストログイン用
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    user.name = "ゲスト"
    end
  end

end

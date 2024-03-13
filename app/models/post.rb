class Post < ApplicationRecord

  has_one_attached :image

  belongs_to :user
  belongs_to :genre

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum status: { published: 0, draft: 1 }
  #0:公開中　1:下書き

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 200 }

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
     image.variant(resize_to_limit: [width, height]).processed
  end

  #ソート機能のためscopeヘルパーを使う
  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :reviews_rating_count, -> { joins(:reviews).group(:id).order('AVG(reviews.rating) DESC') }
  scope :favorites_count, -> { left_joins(:favorites).group(:id).order('COUNT(favorites.id) DESC') }

# scope :latest, -> {order(created_at: :desc)}
# order・・・データの取り出し
# Latest・・・任意の名前で定義する
# order(created_at: :desc)
# created_at・・・投稿日のカラム
# desc・・・昇順
# asc・・・降順

  def save_tag(sent_tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  def avg_score
    unless self.reviews.empty?
      reviews.average(:rating).round(1).to_f
    else
      0.0
    end
  end

  def review_score_percentage
    unless self.reviews.empty?
      reviews.average(:rating).round(1).to_f*100/5
    else
      0.0
    end
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  

  def self.search_by(keyword)
    published.where('title LIKE ? or content LIKE ?', "%#{keyword}%", "%#{keyword}%")
  end

end

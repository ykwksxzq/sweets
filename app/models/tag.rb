class Tag < ApplicationRecord

  has_many :post_tags,dependent: :destroy, foreign_key: 'tag_id'
  # タグは複数の投稿を持つ　それは、post_tagsを通じて参照できる
  has_many :posts,through: :post_tags

  validates :name, uniqueness: true, presence: true

  # Ransack用の検索スコープを追加
  scope :search, ->(query) {
    ransack(name_cont: query).result(distinct: true)
  }

end

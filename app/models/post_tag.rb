class PostTag < ApplicationRecord

  belongs_to :post
  belongs_to :tag

  validates :post_id, presence: true
  validates :tag_id, presence: true

  def self.search(search)
    return PostTag.all unless search
     PostTag.where('name LIKE(?)', "%#{search}%")
  end

end

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates_uniqueness_of :user_id, scope: :post_id
  validates :rating, presence: true
  validates :content, presence: true, length: { maximum: 200 }

  scope :order_by_rating, -> { order(rating: :desc) }


end

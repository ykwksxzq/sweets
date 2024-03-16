class Review < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates_uniqueness_of :user_id, scope: :post_id
  validates :score, presence: true
  validates :content, presence: true, length: { maximum: 100 }

  scope :order_by_rating, -> { order(score: :desc) }


end

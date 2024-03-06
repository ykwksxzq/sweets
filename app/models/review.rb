class Review < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :rating, presence: true
  validates :content, length: { maximum: 200 }
end

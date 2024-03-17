class Review < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates_uniqueness_of :user_id, scope: :post_id
  validates :score, presence: true
  validates :content, presence: true, length: { maximum: 100 }

 #ソート機能のためscopeヘルパーを使う
  scope :latest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :highest_score, -> { order(score: :desc) }
  scope :lowest_score, -> { order(score: :asc) }
end

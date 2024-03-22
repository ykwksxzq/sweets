class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post
  å
  validates :user_id, uniqueness: {scope: :post_id}

end

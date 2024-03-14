class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(query)
    where("title LIKE ? OR content LIKE ?", "%#{query}%", "%#{query}%")
      .or(Tag.where("name LIKE ?", "%#{query}%").joins(:posts))
      .distinct
  end

end

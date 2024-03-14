module ApplicationHelper
  def render_stars(rating)
    full_stars = rating.floor
    half_star = (rating - full_stars).round(1) >= 0.5
    empty_stars = 5 - full_stars - (half_star ? 1 : 0)
    content_tag(:div, class: 'star-rating') do
    (1..full_stars).map { content_tag(:i, '', class: 'fas fa-star') }.join +
    (half_star ? [content_tag(:i, '', class: 'fas fa-star-half-alt')] : []) +
    (1..empty_stars).map { content_tag(:i, '', class: 'far fa-star') }.join
  end
  end
end

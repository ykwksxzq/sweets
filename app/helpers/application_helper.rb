module ApplicationHelper
 # ヘルパーメソッド
 def render_stars(score)
  full_stars = score.floor
  half_star = (score - full_stars).round(1) == 0.5
  empty_stars = 5 - (full_stars + (half_star ? 1 : 0))

    content_tag(:div, class: 'star-rating') do
  stars = (1..full_stars).map { content_tag(:i, '', class: 'fas fa-star') }.join
  stars += half_star ? content_tag(:i, '', class: 'fas fa-star-half-alt') : ''
  stars += (1..empty_stars).map { content_tag(:i, '', class: 'far fa-star') }.join
  raw(stars)  # rawメソッドを使用してHTMLエスケープを防ぐ
  end
 end
end

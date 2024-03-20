module ApplicationHelper

  #current_userでない場合
  def different_user?(user)
    current_user != user
  end



end


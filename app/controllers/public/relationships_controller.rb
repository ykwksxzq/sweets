class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    flash[:notice] = "#{user.name}さんをフォローしました"
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    flash[:notice] = "#{user.name}さんのフォローを外しました"
    redirect_to  request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings.page(params[:page]).per(10)
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers.page(params[:page]).per(10)
  end
end
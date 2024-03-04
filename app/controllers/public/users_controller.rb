class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = Post.published.where(user_id: params[:id]).page(params[:page]).per(4).order(created_at: :desc)
  end


end

class Admin::UsersController < ApplicationController
   before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(status: :published).where(user_id: params[:id]).page(params[:page]).per(5).order(created_at: :desc)
  end









  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end

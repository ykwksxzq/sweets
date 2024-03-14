class Admin::UsersController < ApplicationController
   before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(status: :published).page(params[:page]).per(5)
  end









  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end

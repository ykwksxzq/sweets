class Admin::UsersController < ApplicationController
   before_action :authenticate_admin!

  def index
    @users = User.all
  end









  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end

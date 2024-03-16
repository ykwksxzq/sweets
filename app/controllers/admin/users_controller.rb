class Admin::UsersController < ApplicationController
   before_action :authenticate_admin!


  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(status: :published).where(user_id: params[:id]).page(params[:page]).per(5).order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id), notice: '会員情報の更新が完了しました。'
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end
end

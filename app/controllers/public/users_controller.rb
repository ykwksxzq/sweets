class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = Post.published.where(user_id: params[:id]).page(params[:page]).per(4).order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      flash[:notice] = "会員情報の更新が完了しました"
      redirect_to mypage_path(@user.id)
    else
      flash.now[:alert] = "登録できませんでした。お手数ですが、入力内容をご確認の上再度お試しください"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end

end

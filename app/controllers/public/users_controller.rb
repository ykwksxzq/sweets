class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = Post.published.where(user_id: params[:id]).page(params[:page]).per(4).order(created_at: :desc)
    @reviews = current_user.reviews.page(params[:page]).per(12)
    @favorites = current_user.favorites.page(params[:page]).per(12).order(created_at: :desc)
    @post_drafts = Post.draft.where(user_id: params[:id]).page(params[:page]).per(3).order(created_at: :desc)
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

  def destroy
   current_user.update(is_withdrawn: true)
   sign_out_and_redirect(current_user)
   flash[:notice] = "退会処理を実行いたしました"
   redirect_to root_path
  end

  def mysweets
    @posts = current_user.posts.where(status: :published).page(params[:page]).per(12).order(created_at: :desc)
  end

  def myreviews
    @reviews = current_user.reviews.page(params[:page]).per(12).order(created_at: :desc)
  end

  def myfavorites
    @favorites = current_user.favorites.page(params[:page]).per(12).order(created_at: :desc)
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end

end

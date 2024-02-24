class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genre = Genre.new
    @genres = Genre.all
  end

  def create
    @genre = Genre.new(genre_params)
    @genres = Genre.all
    if @genre.save
      flash[:notice] = "投稿に成功しました。"
      redirect_to admin_genres_path
    else
      flash[:alert] = "投稿できませんでした。お手数ですが、入力内容をご確認の上再度お試しください。"
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      flash[:notice] = "投稿内容を変更しました。"
      redirect_to admin_genres_path
    else
      flash[:alert] = "投稿内容を変更できませんでした。お手数ですが、入力内容をご確認の上再度お試しください。"
      render :edit
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    if @genre.destroy
      flash[:notice] = "投稿を削除しました"
      redirect_to admin_genres_path
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

end

class Public::GenresController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.published.page(params[:page]).per(12).order(created_at: :desc)
    @genres = Genre.all
    @tag_list = Tag.joins(:posts).where(posts: { status: 'published' }).uniq

     if params[:genre_id].present?
       @genre = Genre.find(params[:genre_id])
       @posts = @genre.posts
       @posts = @posts.published.page(params[:page]).per(12).order(created_at: :desc)
     end
  end

 private

 def genre_rarams
    params.require(:genre).permit(:name)
 end
end

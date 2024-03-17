class Admin::PostsController < ApplicationController

 def index
    @posts = Post.where(status: :published)

    #検索用
    if params[:query].present?
      @posts = @posts.search(params[:query])
      flash[:notice] = "検索結果を表示しました。"
    end

    #ソート機能用
    @posts = case params[:sort]
           when 'latest'
             @posts.latest
           when 'oldest'
             @posts.oldest
           when 'highest_rated'
             @posts.reviews_rating_count
           when 'most_favorites'
             @posts.favorites_count
           else
             @posts.latest # デフォルトのソート条件
           end.page(params[:page]).per(12)

    @tag_list = Tag.joins(:posts).where(posts: { status: 'published' }).uniq
    @genres = Genre.all

    render :index
 end



end

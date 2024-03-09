class Public::ReviewsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    @reviews = @post.reviews
    
     # 点数が高い順に並び替えてレビューを取得
    @reviews_high_rating = @post.reviews.order_by_rating
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash[:notice] = "レビューを投稿しました"
      redirect_to post_reviews_path(@review.post)
    else
      @post = Post.find(params[:post_id])
      flash.now[:alert] = "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください。"
      render "public/posts/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :post_id, :rating, :content)
  end

end
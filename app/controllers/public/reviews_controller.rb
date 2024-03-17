class Public::ReviewsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    @reviews = @post.reviews.page(params[:page]).per(10).order(created_at: :desc)
    @review = Review.new

    # ソート機能用のコピーを作成する
    sorted_reviews = @post.reviews.page(params[:page]).per(10)

    @reviews = case params[:sort]
          when 'latest'
             sorted_reviews.latest
           when 'oldest'
             sorted_reviews.oldest
           when 'highest_score'
             sorted_reviews.highest_score
           when 'lowest_score'
             sorted_reviews.lowest_score
           else
             sorted_reviews.latest # デフォルトのソート条件
           end.per(10).order(created_at: :desc)

    render :index
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash[:notice] = "レビューを投稿しました"
      redirect_to post_reviews_path
    else
      @post = Post.find(params[:post_id])
      flash.now[:alert] = "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください。"
      render "public/posts/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :post_id, :score, :content)
  end
end
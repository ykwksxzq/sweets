class Admin::ReviewsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @reviews = Review.all
  end

  def show
    @post = Post.find(params[:id])
    @reviews = @post.reviews.page(params[:page]).per(10).order(created_at: :desc)

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

    render :show
  end

  def destroy
   Review.find(params[:id]).destroy
   redirect_to admin_review_path(params[:post_id]), notice: "不適切なコメントを削除しました"
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :post_id, :score, :content)
  end


end

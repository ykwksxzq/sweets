class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
      flash[:notice] = "コメントを送信しました"
      redirect_to post_path(post)
    else
      @post = Post.find(params[:post_id])
      flash[:alert] = "コメントを送信できませんでした。お手数ですが、入力内容をご確認の上再度お試しください"
      redirect_to post_path(post)
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:notice] = "コメントを削除しました"
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :post_id,:content)
  end

end

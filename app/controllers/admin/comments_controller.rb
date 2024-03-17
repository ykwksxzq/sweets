class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = Comment.all
  end

  def destroy
   Comment.find(params[:id]).destroy
   redirect_to admin_post_path(params[:post_id]), notice: "不適切なコメントを削除しました"
  end


  private

  def comment_params
   params.require(:comment).permit(:user_id, :post_id, :content)
  end

end

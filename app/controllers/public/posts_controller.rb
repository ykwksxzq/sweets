class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(',')

    # 投稿ボタンを押下した場合
    if params[:post][:status] == "published"
       if @post.save(is_published: true)
          redirect_to post_path(@post.id), notice: "投稿を公開しました！"
       else
          @post.save_tag(tag_list)
          flash.now[:alert] = "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください。"
          render :new
       end
        # 下書きボタンを押下した場合
    else
        if @post.save(is_draft: true)
           flash[:notice] = "下書きを保存しました"
           redirect_to user_path(current_user), notice: "投稿を下書き保存しました！"
        else
           flash.now[:alert] = "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください。"
           render :new
        end
    end
  end




  private

  def post_params
    params.require(:post).permit(:user_id, :genre_id, :title, :content, :status, :image, tag_ids: [])
  end

end

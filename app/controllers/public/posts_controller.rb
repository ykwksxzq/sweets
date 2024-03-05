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

  def index
    @posts = Post.where(status: :published).page(params[:page]).per(12)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list =  @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(',') #入力されたタグを受け取る

    if @post.update(post_params) #もしpostの情報が更新されたら
      if params[:post][:status]== "published"
        @old_relations = PostTag.where(post_id: @post.id) # このpost_idに紐づいていたタグを@oldに入れる

        @old_relations.each do |relation| # それらを取り出し、消す。消し終わる
        relation.delete
      end
        @post.save_tag(tag_list)
        redirect_to post_path(@post.id), notice: "投稿を更新しました！"
      else
        redirect_to posts_path, notice: '下書きに登録しました。'
      end
    else
      render :edit, alert: "投稿を公開できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
    end
  end

  def destroy
   @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "投稿を削除しました"
      redirect_to posts_path
    end
  end





  private

  def post_params
    params.require(:post).permit(:user_id, :genre_id, :title, :content, :status, :image, tag_ids: [])
  end

end

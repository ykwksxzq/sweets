class Public::PostsController < ApplicationController
 before_action :authenticate_user!
 before_action :is_matching_login_user, only:[:edit, :update, :destroy]


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
        # タグを保存
        @post.save_tags(tag_list)
         flash[:notice] = "投稿を公開しました"
         redirect_to post_path(@post.id)
       else
         @post.save_tag(tag_list)
         flash.now[:alert] = "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください。"
         render :new
       end
        # 下書きボタンを押下した場合
    else
        if @post.save(is_draft: true)
           # タグを保存
           @post.save_tags(tag_list)
           flash[:notice] = "下書きに保存しました"
           redirect_to mypage_path(current_user)
        else
           flash.now[:alert] = "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください。"
           render :new
        end
    end
  end

  def index
    @posts = Post.where(status: :published).order(updated_at: :desc)

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
           end.page(params[:page]).per(9)

    @tag_list = Tag.joins(:posts).where(posts: { status: 'published' }).uniq
    @genres = Genre.all

    render :index
  end

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
    @review = Review.new
    @reviews = @post.reviews.page(params[:page]).per(5).order(created_at: :desc)
    @comment = Comment.new
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
        redirect_to mypage_path(current_user), notice: '下書きに登録しました。'
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

  def search_tag
    @tag_list = Tag.joins(:posts).where(posts: { status: 'published' }).uniq
    @tag = Tag.find(params[:tag_id])
    @genres = Genre.all
    @posts = @tag.posts.where(status: :published).page(params[:page]).per(9).order(updated_at: :desc)
  end

  def confirm
    @posts = current_user.posts.where(status: :draft).page(params[:page]).per(9).order(updated_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :genre_id, :title, :content, :status, :rating, :star, :image, tag_ids: [])
  end

  def is_matching_login_user
    @post = Post.find(params[:id])
    unless @post.user.id == current_user.id
      redirect_to posts_path
    end
  end

end
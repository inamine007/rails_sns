class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).page(params[:page]).recent
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_url, notice: "「#{@post.title}」をつぶやきました。"
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.all
    @comment = @post.comments.build
    @like = Like.new
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def update
    @post.update!(post_params)
    redirect_to posts_url, notice: "「#{@post.title}」を更新しました。"
  end

  def destroy
    @post.destroy
    redirect_to posts_url, alert: "「#{@post.title}」を削除しました。"
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end

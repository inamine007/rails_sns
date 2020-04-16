class UsersController < ApplicationController
  skip_before_action :login_required, only: [:top, :new, :create]
  before_action :correct_user, only: [:mypage, :edit, :destroy, :update]

  def top
  end

  def index
    @users = User.all.recent
  end

  def show
    @user = User.find(params[:id])
  end

  def mypage
    @posts = current_user.posts.all.recent
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to mypage_user_path(@user), notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # user = User.find(params[:id])
    @user.update!(user_params)
    redirect_to mypage_user_path(@user), notice: "ユーザー「#{@user.name}」を更新しました。"
  end

  def destroy
    # user = User.find(params[:id])
    @user.destroy
    redirect_to root_url, notice: "ユーザー「#{@user.name}」を削除しました。"
  end

  def following
    @user = User.find(params[:id])
    @users = @user.followings
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_followers'
  end

  private

  def user_params
    params.require(:user).permit(:name, :mail, :image, :birthday, :introduce, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url, alert: "権限がありません" unless current_user.id == @user.id
  end
end

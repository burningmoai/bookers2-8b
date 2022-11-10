class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # user.followings/followersで取得可
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @two_day_ago_book =@books.created_two_day_ago
    @three_day_ago_book =@books.created_three_day_ago
    @four_day_ago_book =@books.created_four_day_ago
    @five_day_ago_book =@books.created_five_day_ago
    @six_day_ago_book =@books.created_six_day_ago
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  # def followings
    # user = User.find(params[:id])
    # @users = user.followings
  # end

  # def followers
    # user = User.find(params[:id])
    # @users = user.followers
  # end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end

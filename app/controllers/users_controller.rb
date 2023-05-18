class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today = Date.today
    @daily_books = (0..6).map do |days_ago|
      date = @today - days_ago
      books_count = @books.where(created_at: date.all_day).count
      [date, books_count]
    end.to_h
    if params[:date]
      @books_count = @user.books.where(created_at: params[:date].to_date.all_day).count
    else
      @books_count = 0
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def following
    @users = User.find(params[:id]).following
  end

  def followers
    @users = User.find(params[:id]).followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user)
    elsif @user.name == "guestuser"
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール画面へ遷移できません'
    end
  end
end

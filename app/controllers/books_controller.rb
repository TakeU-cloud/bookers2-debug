class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @book.update(views_count: @book.views_count + 1)

    @today = Date.today
    @daily_book_comments = (0..6).map do |days_ago|
      date = @today - days_ago
      comments_count = @book.book_comments.where(created_at: date.all_day).count
      [date, comments_count]
    end.to_h
  end

  def index
    @book = Book.new

    session[:sort] = params[:sort] if params[:sort].present?
    session[:sort] = 'created_at' if session[:sort].blank?
    if session[:sort] == 'newest'
      @sort = 'created_at'
      @books = Book.order(@sort => :desc).all
    elsif session[:sort] == 'highest'
      @sort = 'score'
      @books = Book.order(@sort => :desc).all
    else
      @books = Book.left_joins(:favorites)
                   .select("books.*, SUM(CASE WHEN favorites.created_at BETWEEN '#{1.week.ago}' AND '#{Time.now}' THEN 1 ELSE 0 END) AS weekly_favorites_count")
                   .group('books.id')
                   .order('weekly_favorites_count DESC')
    end
    @nearby_books = Book.nearby_books(@book.latitude, @book.longitude)
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      @nearby_books = Book.nearby_books(@book.latitude, @book.longitude)
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @nearby_books = Book.nearby_books(@book.latitude, @book.longitude)
  end

  def update
    @book = Book.find(params[:id])
    @nearby_books = Book.nearby_books(@book.latitude, @book.longitude)
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :score, :tag, :address, :latitude, :longitude)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    unless @user == current_user
      redirect_to books_path
    end
  end
end

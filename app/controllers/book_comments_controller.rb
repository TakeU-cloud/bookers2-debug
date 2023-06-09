class BookCommentsController < ApplicationController
  before_action :is_matching_login_user, only: [:destroy]

  def create
    @book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save

    @today = Date.today
    @daily_book_comments = (0..6).map do |days_ago|
      date = @today - days_ago
      comments_count = @book.book_comments.where(created_at: date.all_day).count
      [date, comments_count]
    end.to_h

    respond_to do |format|
      format.html {
        redirect_back(fallback_location: book_path(@book))
      }
      format.js
    end
  end

  def destroy
    book_comment = BookComment.find(params[:id])
    @book = book_comment.book
    book_comment.destroy

    @today = Date.today
    @daily_book_comments = (0..6).map do |days_ago|
      date = @today - days_ago
      comments_count = @book.book_comments.where(created_at: date.all_day).count
      [date, comments_count]
    end.to_h

    respond_to do |format|
      format.html {
        redirect_back(fallback_location: book_path(@book))
      }
      format.js
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def is_matching_login_user
    comment = BookComment.find(params[:id])
    user = comment.user
    unless user.id == current_user.id
      redirect_to books_path
    end
  end
end

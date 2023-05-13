class BookCommentsController < ApplicationController
  before_action :is_matching_login_user, only: [:destroy]

  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    redirect_back(fallback_location: book_path(book))
  end

  def destroy
    BookComment.find(params[:id]).destroy
    redirect_back(fallback_location: book_path(params[:book_id]))
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

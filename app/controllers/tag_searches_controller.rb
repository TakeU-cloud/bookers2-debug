class TagSearchesController < ApplicationController
  def search
    @books = Book.where(tag: params[:tag])
  end
end

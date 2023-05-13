class SearchesController < ApplicationController
  def search
    @search_word = params[:search_word]
    @search_target = params[:search_target]
    @search_method = params[:search_method]

    if @search_target == "users"
      @results = User.search(@search_word, @search_method)
    else
      @results = Book.search(@search_word, @search_method)
    end
  end
end

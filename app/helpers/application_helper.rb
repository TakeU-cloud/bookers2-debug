module ApplicationHelper
  def books_current_sort(sort_option)
    'selected' if session[:sort] == sort_option
  end
end

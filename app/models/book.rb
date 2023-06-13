class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search(word, method)
    if method == "完全一致"
      where(title: word)
    elsif method == "前方一致"
      where("title LIKE ?", "#{word}%")
    elsif method == "後方一致"
      where("title LIKE ?", "%#{word}")
    else
      where("title LIKE ?", "%#{word}%")
    end
  end

  def book_url
    Rails.application.routes.url_helpers.book_url(self, only_path: true)
  end

  def user_profile_image_url
    user.get_profile_image
  end

  def self.nearby_books(latitude, longitude, distance_in_km = 1)
    if latitude.nil? || longitude.nil?
      return Book.none
    end
    where.not(latitude: nil, longitude: nil).near([latitude, longitude], distance_in_km)
  end

  def daily_comments_count(days_range = 0..6)
    today = Date.today

    days_range.map do |days_ago|
      date = today - days_ago
      comments_count = book_comments.where(created_at: date.all_day).count
      [date, comments_count]
    end.to_h
  end
end

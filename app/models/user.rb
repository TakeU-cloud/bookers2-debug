class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # N:N relations of follow(active) and followed(passive) between users
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # N:N relations of direct messages between user_a and user_b
  has_many :sent_messages, class_name: 'DirectMessage', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'DirectMessage', foreign_key: 'receiver_id', dependent: :destroy
  # N:N relations between user_a and user_b through group_users
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id'

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id) unless self == other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy if following?(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(word, method)
    if method == "完全一致"
      where(name: word)
    elsif method == "前方一致"
      where("name LIKE ?", "#{word}%")
    elsif method == "後方一致"
      where("name LIKE ?", "%#{word}")
    else
      where("name LIKE ?", "%#{word}%")
    end
  end

  def today_books
    self.books.where(created_at: Time.zone.now.all_day)
  end

  def yesterday_books
    self.books.where(created_at: 1.day.ago.all_day)
  end

  def this_week_books
    self.books.where(created_at: Time.zone.now.all_week)
  end

  def last_week_books
    self.books.where(created_at: 1.week.ago.all_week)
  end

  def percent_increase(current_period, last_period)
    if last_period.count == 0
      100
    else
      (((current_period.count - last_period.count) / last_period.count.to_f) * 100).round
    end
  end

  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
end

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :group_messages, dependent: :destroy

  has_one_attached :group_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end
end

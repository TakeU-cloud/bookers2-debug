class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, authentication_keys: [:name]

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true, presence: true
end

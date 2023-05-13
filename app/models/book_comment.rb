class BookComment < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :comment, presence: true
  validates :comment, format: { with: /\S/ }
end

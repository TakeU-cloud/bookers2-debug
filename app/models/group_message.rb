class GroupMessage < ApplicationRecord
  belongs_to :group
  validates :title, presence: true
  validates :content, presence: true, length:{maximum:200}
end

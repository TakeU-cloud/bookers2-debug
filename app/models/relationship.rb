class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  after_destroy :destroy_direct_messages

  private

  def destroy_direct_messages
    DirectMessage.where("sender_id = ? AND receiver_id = ?",
                        follower_id, followed_id)
                 .or(DirectMessage.where("sender_id = ? AND receiver_id = ?",
                        followed_id, follower_id)).destroy_all
  end
end

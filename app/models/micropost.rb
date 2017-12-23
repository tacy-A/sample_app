class Micropost < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, styles: { medium: "300x300>", thumb: "50x50>" }
  default_scope -> { order('created_at DESC') }
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png image/gif)
  validates_attachment_size :image, :less_than=>1.megabyte
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
           user_id: user.id)
  end
end

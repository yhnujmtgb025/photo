class Photo < ApplicationRecord
  belongs_to :user

  mount_uploader :image, AvatarUploader
  serialize :image, JSON

  validates :title,  length: { minimum: 1, maximum: 140 },presence: true
  validates :desc,  length: { minimum: 1, maximum: 300 },presence: true
  validates :state, presence: true

end

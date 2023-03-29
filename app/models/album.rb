class Album < ApplicationRecord
  belongs_to :user
  has_many :photos

  mount_uploader :avatar, AvatarUploader
  serialize :avatar, JSON

  # validates :title, presence: true
  # validates :desc, presence: true
  # validates :active, presence: true
end

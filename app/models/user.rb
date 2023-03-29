class User < ApplicationRecord
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy
  mount_uploader :avatar, AvatarUploader
  serialize :avatars, JSON

  validates :first_name, presence: true,  length: { minimum: 1, maximum: 25 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 25 }
  validates :email, presence: true,  uniqueness: true ,length: { minimum: 11, maximum: 255 }
  validates :password,  confirmation: true , length: {minimum: 1, maximum: 64}, presence: true
  # validates :confirm_password, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable
end

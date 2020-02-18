class User < ApplicationRecord
  validates :name, presence: true, length: {minimum: 2, maximum: 20 }
  validates :introduction, length: {maximum: 49 }
  has_many :books,dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :image 
  attachment :profile_image
end

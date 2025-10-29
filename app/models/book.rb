class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  def favorited_by?(uesr)
    favorites.exists?(user_id: user.id)
  end
  has_many :favorited_users,through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

end

class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  def favorited_by?(uesr)
    favorites.exists?(user_id: user.id)
  end
  has_many :favorited_users,through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  acts_as_taggable_on :tags
  scope :created_within_week, -> {
  where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day)
}

  scope :sort_by_favorites, -> {
    left_joins(:favorites)
      .group(:id)
      .order(Arel.sql('COUNT(favorites.id) DESC'))
  }


  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

    def self.looks(search, word)
    if search == "perfect_match"
      Book.where("title LIKE ?", "#{word}")
    elsif search == "forward_match"
      Book.where("title LIKE ?", "#{word}%")
    elsif search == "backward_match"
      Book.where("title LIKE ?", "%#{word}")
    elsif search == "partial_match"
      Book.where("title LIKE ?", "%#{word}%")
    else
      Book.all
    end
  end
end

class Product < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_full_text, against: {
    title: "A",
    description: "B"
  }
  ORDER_BY = {
    newest: "created_at DESC",
    expensive: "price DESC",
    cheapest: "price ASC"
  }

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  has_many :favorites, dependent: :destroy
  has_one_attached :photo
  belongs_to :category
  belongs_to :user, default: -> { Current.user }

  def owner?
    user_id == Current.user&.id
  end

  def favorite!
    favorites.create(user: Current.user)
  end

  def unfavorite!
    favorites.find_by(user: Current.user).destroy
  end
end

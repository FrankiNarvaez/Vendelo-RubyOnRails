module Favoritable
  extend ActiveSupport::Concern

  included do
    def favorite!
      favorites.create(user: Current.user)
    end

    def unfavorite!
      favorite.destroy
    end

    def favorite
      favorites.find_by(user: Current.user)
    end
  end
end

class Favorite < ApplicationRecord
    ## join table between movies and users.
    belongs_to :user
    belongs_to :movie

    ## no repeat favorites allowed.
    validates :user_id, uniqueness: { scope: :movie_id }

    ## methods to glean info.
    def self.favorite_movies

      # movie ids, in "all" and "unique" formats.
      all_favorites = self.all.map{|favorite| favorite.movie_id}
      unique = all_favorites.uniq

      # count for each individual movie.
      counts = unique.map do |id|
        all_favorites.count(id)
      end

      # merge the count and unique arrays in an array of hashes.
      movies_with_count = unique.map.with_index{ |id, i| {movie: id, count: counts[i]} }

      # sort by highest count
      sorted = movies_with_count.sort_by{|movie_hash| movie_hash[:count]}

      sorted.reverse
    end

    def self.most_favorite_movie_title
        Movie.find(self.favorite_movies.first[:movie]).title
    end

    def self.most_favorite_movie_count
        self.favorite_movies.first[:count]
    end


end

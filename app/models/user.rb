class User < ApplicationRecord
    # accessing the triple join
    has_many :comparisons
    has_many :inferiors, through: :comparisons
    has_many :superiors, through: :comparisons

    # accessing movies directly through favorites many-to-many join
    has_many :favorites
    has_many :movies, through: :favorites

    # bcrypt method for authorization (logging in)
    has_secure_password

    def find_favorite(movie)
        self.favorites.find_by(movie_id: movie.id)
    end

#################### calculating comparison movie pool

    def genre_count
        # movie genres, in "all" and "unique" formats.
        all_genres = self.movies.map{|movie| movie.split_genres}.flatten
        genres_unique = all_genres.uniq

        # count of each individual genre.
        counts = genres_unique.map do |genre|
          all_genres.count(genre)
        end

        # merge the count and unique genre array.
        genres_with_count = genres_unique.map.with_index{ |genre, i| {genre: genre, count: counts[i]} }

        # sort by highest count
        sorted = genres_with_count.sort_by{|genre_hash| genre_hash[:count]}

        # sort from most counts to least.
        sorted.reverse
    end

    def genre_order
        self.genre_count.map{|movie| movie[:genre]}[0..4]
    end

    def movies_by_genre_and_relevancy
        reorder = []

        self.genre_order.each do |genre|
          self.relevant_movie_range.each do |movie|
            if movie.genre.include?(genre)
              reorder << movie
            end
          end
        end
        reorder
    end

#################### Recommendation calculations

    def reigning_champ
        Movie.find(self.comparisons.last.superior_id)
    end

    def avg_reigning_champ_and_favorites
        (self.reigning_champ.imdbRating + self.favorite_average_rating)/2
    end

    def recommendation_low
        self.avg_reigning_champ_and_favorites - 0.4
    end

    def recommendation_high
        self.avg_reigning_champ_and_favorites + 0.4
    end

    def recommendation_relevant_movie_range
          # get average rating & therefore relevant rating range.
          low = self.rating_range_low
          high = self.rating_range_high
          relevant_movies = Movie.all.select{|movie| movie.imdbRating.between?(low, high)}

          # sort relevant movies by votes then rating.
          sorted = relevant_movies.sort_by{|movie| [movie.imdbVotes, movie.imdbRating]}.reverse
    end

    def get_4_recommendations
        self.recommendation_relevant_movie_range.sample(4)
    end

#################### Comparison calculations
    def favorite_movie_ids
        self.movies.map {|movie| movie.id}
    end

    def favorite_movie_ratings
        self.movies.map {|movie| movie.imdbRating}
    end

    def favorite_total
        self.movies.count
    end

    def favorite_average_rating
        favorite_movie_ratings.sum/favorite_total
    end

    def rating_range_low
        self.favorite_average_rating - 0.4
    end

    def rating_range_high
        self.favorite_average_rating + 0.4
    end

    def relevant_movie_range
        # get average favorite rating & therefore relevant rating range.
        low = self.rating_range_low
        high = self.rating_range_high
        relevant_movies = Movie.all.select{|movie| movie.imdbRating.between?(low, high)}

        # sort relevant movies by votes then rating.
        sorted = relevant_movies.sort_by{|movie| [movie.imdbVotes, movie.imdbRating]}.reverse # sort by rating
    end

end

# potential future helper methods:
# total_votes = sorted.reduce(0){|sum, movie| sum += movie.imdbVotes}
# average_votes = total_votes / sorted.count
# media_movies = Movie.all.select{|movie| movie.media_type == "movie"}
# usa_movies = media_movies.select{|movie| movie.country == "USA"}

# When I want to come back to this project, here are some helpful functions...
# Currently, I'm using the "reigning champ" only to supply the "comparison" recommendation side of the function.

# def all_movies_compared
#     self.comparisons.map{|comp| [comp.superior_id, comp.inferior_id]}.flatten.uniq
# end
#
# def superior_comparison_count
#     self.all_movies_compared.map{|id| self.comparisons.select{|comp| comp.superior_id == id}.count }
# end
#
# def superior_counts_by_movie
#     self.all_movies_compared.zip(self.superior_comparison_count)
# end
#
# def get_reigning_champ_by_number_of_superior_comparisons
#     champ = self.superior_counts_by_movie.sort_by{|arr| arr[1] }.last
#     Movie.find(champ[0])
# end

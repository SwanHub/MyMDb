class User < ApplicationRecord
    has_many :comparisons
    has_many :favorites
    has_many :movies, through: :favorites
    has_secure_password

    def find_favorite(movie)
        self.favorites.find_by(movie_id: movie.id)
    end

#################### calculating comparison movie pool

    def genre_count
        # movie genres, in "all" and "unique" formats.
        all_genres = self.movies.map{|movie| movie.split_genres}.flatten
        genres_unique = all_genres.uniq

        # count for each individual genre.
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

#################### individual user stats

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
        # narrow down to usa movies
        media_movies = Movie.all.select{|movie| movie.media_type == "movie"}
        usa_movies = media_movies.select{|movie| movie.country == "USA"}

        # get average favorite rating & therefore relevant rating range.
        low = self.rating_range_low
        high = self.rating_range_high
        relevant_movies = usa_movies.select{|movie| movie.imdbRating.between?(low, high)}

        # sort relevant movies by votes then rating.
        sorted = relevant_movies.sort_by{|movie| [movie.imdbVotes, movie.imdbRating]}.reverse # sort by rating

        # potential helper method:
        # total_votes = sorted.reduce(0){|sum, movie| sum += movie.imdbVotes}
        # average_votes = total_votes / sorted.count

    end

end

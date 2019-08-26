class StatSheet < ApplicationRecord
    before_save :save_stats

    def save_stats
        self.total_movies = self.total_movies_string
        self.total_votes = self.total_votes_string
        self.avg_votes_per_movie = self.average_votes_string
        self.avg_rating_per_movie = self.average_rating
    end

    def all_movies
        Movie.all.count
    end

    def total_movies_string
        separate_comma(self.all_movies)
    end

    def all_votes
        Movie.all.reduce(0){|sum, movie| sum += movie.imdbVotes}
    end

    def total_votes_string
        separate_comma(self.all_votes)
    end

    def average_votes
        (all_votes/all_movies)
    end

    def average_votes_string
        separate_comma(average_votes)
    end

    def all_ratings
        Movie.all.reduce(0){|sum, movie| sum += movie.imdbRating}
    end

    def average_rating
        (all_ratings / all_movies).round(3)
    end

    def separate_comma(number)
        number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
    end
end

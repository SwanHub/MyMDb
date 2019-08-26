class Movie < ApplicationRecord
    validates :imdbID, uniqueness: true
    #self join
    has_many :better_movies, foreign_key: :superior_id, class_name: "Comparison"
    has_many :inferiors, through: :better_movies
    has_many :worse_movies, foreign_key: :inferior_id, class_name: "Comparison"
    has_many :superiors, through: :worse_movies

    # favorites join
    has_many :favorites
    has_many :users, through: :favorites

    def self.all_genres
        genres = self.all.map{|movie| movie.genre}
        separated_genres = genres.map{|genres| genres.split(", ")}.flatten
        separated_genres.uniq
    end

    def split_genres
        self.genre.split(", ")
    end

end

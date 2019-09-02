class Movie < ApplicationRecord
    validates :imdbID, uniqueness: true
    # triple join
    has_many :superior_comparisons, foreign_key: :superior_id, class_name: "Comparison"
    has_many :inferiors, through: :superior_comparisons
    has_many :fans, through: :superior_comparisons
    
    has_many :inferior_comparisons, foreign_key: :inferior_id, class_name: "Comparison"
    has_many :superiors, through: :inferior_comparisons
    has_many :haters, through: :inferior_comparisons

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

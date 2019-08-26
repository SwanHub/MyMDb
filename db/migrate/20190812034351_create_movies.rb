class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.string :rated
      t.string :released
      t.string :runtime
      t.string :genre
      t.string :director
      t.string :writer
      t.string :actors
      t.text :plot
      t.string :language
      t.string :country
      t.string :awards
      t.string :poster_url
      t.string :rotten_tomatoes
      t.integer :metascore
      t.float :imdbRating
      t.integer :imdbVotes
      t.string :imdbID
      t.string :media_type
      t.string :production_companies
      t.string :website_url

      t.timestamps
    end
  end
end

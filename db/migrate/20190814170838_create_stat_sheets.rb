class CreateStatSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :stat_sheets do |t|
      t.string :total_movies
      t.string :total_votes
      t.string :avg_votes_per_movie
      t.integer :avg_rating_per_movie

      t.timestamps
    end
  end
end

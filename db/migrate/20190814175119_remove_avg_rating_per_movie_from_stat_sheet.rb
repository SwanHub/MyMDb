class RemoveAvgRatingPerMovieFromStatSheet < ActiveRecord::Migration[5.2]
  def change
      remove_column :stat_sheets, :avg_rating_per_movie
      add_column :stat_sheets, :avg_rating_per_movie, :float
  end
end

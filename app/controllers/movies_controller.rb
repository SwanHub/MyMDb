class MoviesController < ApplicationController

    def index
        @stats = StatSheet.first
    end

    def show
        @movie = Movie.find(params[:id])
        @favorite = Favorite.new
    end

    def search
      found_movie = Movie.all.find{|movie| movie.title.include?(params["movie_name"])}
      if found_movie
          @movie = found_movie
          redirect_to movie_path(@movie)
      else
          redirect_to movies_path, flash: { retry: "Try again..." }
      end
    end

    def usershow
      @favorite = Favorite.new
      @user = User.find(params["user"]["id"])
      found_movie = Movie.all.find{|movie| movie.title.include?(params["movie_name"])}
      if found_movie
          @movie = found_movie
      else
          redirect_to user_search_path(@user), flash: { retry: "Try again..." }
      end
    end

end

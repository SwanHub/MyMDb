class FavoritesController < ApplicationController

    def index
        @favorites = Favorite.all
    end

    def show
        @favorite = Favorite.find(params[:id])
    end

    def create
        @user = current_user

        if @user.movies <= 10

          @favorite = Favorite.new(user_id: @user.id, movie_id: params["movie"]["id"])
          if @favorite.save
            redirect_to user_path(@user), flash: {notice: "You added #{Movie.find(params["movie"]["id"]).title} to favorites!"}
          else
            redirect_to user_search_path(@user), flash: {alert: "I know you love that movie, but no duplicates!"}
          end
          
        end
    end

    def destroy
        @user = User.find(params[:user_id])
        Favorite.delete(params[:id])
        redirect_to user_path(@user)
    end

end

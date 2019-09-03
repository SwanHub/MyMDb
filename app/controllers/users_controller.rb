class UsersController < ApplicationController

   def show
      @user = User.find(params[:id])
   end

   def new
      @user = User.new
   end

   def create
      @user = User.new(user_params)

      if @user.save
        redirect_to login_path, flash: {notice: "Welcome #{@user.name}! Log in to start adding favorites!"}
      else
        flash[:alert] = "Username has been claimed."
        render :new
      end
   end

   def search
      @stats = StatSheet.first
      @user = User.find(params[:id])
   end

   def comparison
      @user = current_user

      if @user.favorites.count > 0
        @comparison = Comparison.new
          # if the user has created comparisons... get the reigning champ
          if @user.comparisons.count > 0
              @movie_1 = Movie.find(@user.comparisons.last.superior_id)

              @movie_2 = @user.movies_by_genre_and_relevancy.sample
              until @movie_2.id != @movie_1.id
                    @movie_2 = @user.movies_by_genre_and_relevancy.sample
              end

          else
              @movie_1 = @user.movies_by_genre_and_relevancy.sample

              @movie_2 = @user.movies_by_genre_and_relevancy.sample
              until @movie_2.id != @movie_1.id
                    @movie_2 = @user.movies_by_genre_and_relevancy.sample
              end
          end

      else
        flash[:retry] = "Add some favorites before I curate your comparisons!"
        redirect_to user_path(current_user)
      end
   end

   def home
   end

   private

   def user_params
      params.require(:user).permit(:name, :password)
   end

end

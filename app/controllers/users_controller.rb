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

          # if the user has created comparisons... get the reigning champ
          if @user.comparisons.count > 0
              # helper methods for variables below.
              reigning_champ = Movie.find(Comparison.last.superior_id)
              relevant_movies = @user.relevant_movie_range

              # variables used in view.
              @movie_1 = reigning_champ
          else
              @movie_1 = @user.relevant_movie_range.sample
              @movie_2 = @user.relevant_movie_range.sample
              @comparison = Comparison.new
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

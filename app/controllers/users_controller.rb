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
      # helper methods for variables below.
      reigning_champ = Movie.find(Comparison.last.superior_id)
      @user = User.find(params[:id])
      relevant_movies = @user.relevant_movie_range

      # variables used in view.
      @movie_1 = reigning_champ
      @movie_2 = relevant_movies.sample
      @comparison = Comparison.new
   end

   def home
   end

   private

   def user_params
      params.require(:user).permit(:name, :password)
   end

   # if we create a destroy method, include destroying all relevant comparisons... / favorites.

end

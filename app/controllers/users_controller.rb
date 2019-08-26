class UsersController < ApplicationController

   def index
      @users = User.all
   end

   def show
      @user = User.find(params[:id])
   end

   def new
      @user = User.new
   end

   def create
      @user = User.new(name: params[:user][:name], movie_quote: params[:user][:movie_quote])

      if @user.save
        flash[:notice]
        redirect_to user_path(@user), flash: {notice: "Welcome #{@user.name}! Start adding to your favorites!"}
      else
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

   # if we create a destroy method, include destroying all relevant comparisons... / favorites.

end

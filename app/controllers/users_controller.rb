class UsersController < ApplicationController

   def show
      @user = current_user
   end

   def recommendation
      @user = current_user
      @recommendations = current_user.get_4_recommendations
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

      if @user.movies.count > 0
        @comparison = Comparison.new
        @movie_2 = @user.movies_by_genre_and_relevancy.sample

          # if the user has created comparisons... get the reigning champ
          if @user.comparisons.count > 0
              @movie_1 = Movie.find(@user.comparisons.last.superior_id)
          else
              @movie_1 = @user.movies_by_genre_and_relevancy.sample
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

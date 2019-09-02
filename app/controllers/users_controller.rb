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
        @movie_2 = @user.relevant_movie_range.sample

          # if the user has created comparisons... get the reigning champ
          if @user.comparisons.count > 0
              @movie_1 = Movie.find(Comparison.last.superior_id)
          else
              @movie_1 = @user.relevant_movie_range.sample
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

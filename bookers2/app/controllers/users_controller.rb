class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:edit, :update]
    def index
        @book = Book.new       
        @users = User.all
    end
    def show
        @book = Book.new       
        @user = User.find(params[:id])
        @books = @user.books
    end

    def edit 
        @user = @books
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            redirect_to user_path(@user.id)
            flash[:notice] = "You have updated user successfully."
        else
            render 'edit'
        end
    end

private 
    def correct_user
        user = User.find(params[:id])
        if current_user != user
            redirect_to user_path(current_user)
        end
    end

    def user_params
        params.require(:user).permit(:name, :introduction, :profile_image)
    end
end
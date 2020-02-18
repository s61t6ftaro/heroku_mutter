class BooksController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user_book, only: [:edit, :update]
    def index
        @book = Book.new
        @books = Book.all.order(created_at: :desc)
    end                                                  
    def show
        @book = Book.new
        @book = Book.find(params[:id])
    end

    def edit
        @book = Book.find(params[:id])
    end

    def create
        @book = Book.new(book_params)
        @book.user_id = current_user.id
        if @book.save
            flash[:notice] = "You have creatad mutter successfully."
            redirect_to book_path(@book.id)
        else
            @books = Book.all 
            @user = current_user
            render 'index'
        end
    end

    def update
        @book = Book.find(params[:id])
        if @book.update_attributes(book_params)
            redirect_to book_path
            flash[:notice] = "You have updated mutter successfully."
        else  
            render 'edit'
        end
    end

    def destroy
        @book = Book.find(params[:id])
        @book.destroy
        redirect_to books_path
    end

private
    def correct_user_book
        book = Book.find(params[:id])
        if current_user != book.user
            redirect_to books_path
        end
    end

    def book_params
      params.require(:book).permit(:title, :body)
    end
end

class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    book = Book.find(params[:book_id])
    favorite =
current_user.favorites.new(book_id: book.id)
    favorite.save
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    redirect_back(fallback_location: books_path)
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite =
current_user.favorites.find_by(book_id: @book.id)
    if favorite.present?
       favorite.destroy
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: books_path }
      format.js
    redirect_back(fallback_location: books_path)
    end
  end
end
class BooksController < ApplicationController
before_action :ensure_correct_user,
only: [:edit, :update, :destroy]

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path, notice:
      "権限がありません"
    end
  end

  def show
    @book = Book.find(params[:id])
    unless ViewCount.exists?(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @new_book = Book.new
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    if params[:sort] == "new"
      @books = Book.created_within_week.order(created_at: :desc)
    elsif params[:sort] == "high_rate"
      @books = Book.created_within_week.order(rate: :desc)
    elsif params[:sort] == "favorite"
      @books = Book.created_within_week.sort_by_favorites
    else
      @books = Book.created_within_week
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search_tag
    @user = current_user
    @book_new = Book.new
    @tag = params[:tag]
    @books = Book.tagged_with(@tag)
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate, :tag_list)
  end
end

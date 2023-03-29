class UsersController < ApplicationController

  def index

  end

  def show

  end

  def create
    # puts "xin chaoooooooooozzzzzzzzzzzzzzzzooooooooooooooo"
    # @user = User.find_by_email(params[:user][:email])
    # if @user && @user.valid_password?(params[:user][:password])
    #   redirect_to root_path
    # else
    #   flash[:notice] = "Invalid email/password combination"
    #   redirect_back(fallback_location:  new_user_session_path)
    # end
  end

  def new # signup 

  end



  private

  def required_params
    params.require(:user).permit(:email, :password)
  end

end
# class ABC
#   def CreateArticle
#     author = Author.first
#     book = author.books.create(publisted_at:"1000/10/02")
#     book1=''
#     if Book.last.id
#       book1 = Book.last.id
#     else
#       book1 = 1
#     end
#     article = Book.last.articles.create(author_id:author.id,title:"MUa XUan hoa no",body:book1)
#   end
#  end
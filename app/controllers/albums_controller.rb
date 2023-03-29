class AlbumsController < ApplicationController

  def index
    @albums = Album.page(1).per(20)
  end

  def new
    
  end
  
  def show
    get_album()
    if @albums
      respond_to do |format|
        format.json { render json: @album }
      end
    end
  end

  def create
    @user = User.find(current_user.id)
    album = @user.albums.new(required_params)
    album.state = params[:state]
    album.avatar = params[:album][:file]
    puts "-----------------ad--------------#{album}"
    if album.save
      puts "-----------#-------------------------------"
      redirect_to albums_path
    else
      render "new"
    end
  end

  def edit
    
  end

  def get_album
    @album = Photo.find(params[:id])
  end

  private

  def required_params
    params.require(:album).permit(:title, :desc, :state, :file,:avatar)
  end
end

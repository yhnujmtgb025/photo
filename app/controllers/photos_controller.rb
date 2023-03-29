class PhotosController < ApplicationController
  def index
      @photos = Photo.page(1).per(20)
  end

  def show
    get_photo()
    if @photo
      respond_to do |format|
        format.json { render json: @photo }
      end
    end
  end

  def create
    @user = User.find(current_user.id)
    photo = @user.photos.new(required_params)
    photo.state = params[:state]
    photo.image = params[:photo][:file]
    if photo.save
      puts "-----------#-------------------------------"
      redirect_to photos_path
    else
      render "new"
    end
  end

  def edit
    get_photo()
  end

  def update
    get_photo()
    if @photo
      if params[:photo][:file]
        @photo.image = params[:photo][:file]
      end
      @photo.state = params[:state]
      @photo.title = params[:photo][:title]
      @photo.desc = params[:desc]
      if @photo.save
        redirect_to photos_path
      else
        render "edit"
      end
    end

  end

  def new # signup 

  end

  def get_photo
    @photo = Photo.find(params[:id])
  end

  private

  def required_params
    params.require(:photo).permit(:title, :desc, :state, :file,:avatar)
  end


end

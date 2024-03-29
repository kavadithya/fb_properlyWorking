class UsersController < ApplicationController
#  before_filter :signed_in_user, only: [:edit, :update]
 # before_filter :correct_user,   only: [:edit, :update]
  #before_filter :admin_user,     only: :destroy
  def new
  	@user = User.new
  end
  def show

    if signed_in?
      @user = User.find(params[:id])
    else
      redirect_to root_path
    end
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      sign_in @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  def index
    @users = User.paginate(page: params[:page]) 
  end
  def fb
    @auth_object = request.env['omniauth.auth']['extra']['raw_info']
    if @user_good = User.find_by_email(@auth_object['email'])
      #DO SOMETHING NICE
      sign_in @user_good
      redirect_to @user_good
    else
      @user = User.new(:name => @auth_object['name'], :email => @auth_object['email'], :password => "foobar", :password_confirmation => "foobar")
      if @user.save
        flash[:success] = "Signed in successfully through FB"
        redirect_to @user
        sign_in @user
      else
        render 'new'
      end
    end

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

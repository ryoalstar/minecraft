class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def sign_in

  end

  def my_servers

  end

  def modify_password

  end

  def recover_password

  end
end

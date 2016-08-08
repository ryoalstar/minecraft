class ServersController < ApplicationController

  def index
    @servers = Server.paginate(:page => params[:page], :per_page => 15).order("votes DESC, players DESC")
    @serverCount = @servers.count
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
  end

  def view
    @server = Server.find(params[:id])
  end

  def vote
    @server = Server.find(params[:id])
    if verify_solvemedia_puzzle
      flash[:notice] = "Succesfully voted!"
    else
      flash[:error] = "Error, invalid voting captcha!"
    end

    redirect_to('/server/'+params[:id])


  end
end

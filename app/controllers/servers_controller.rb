class ServersController < ApplicationController

  def index

    if params[:page].eql? '1'
      redirect_to root_path, :status => 301
    end

    @servers = Server.paginate(:page => params[:page], :per_page => 15).includes(:tags).order("votes DESC, players DESC")
    @serverCount = @servers.count
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
  end

  def search_redirect
    redirect_to '/search/'+ params[:search], :status => 301
  end

  def search
    if params[:page].eql? '1'
      redirect_to root_path, :status => 301
    end

    @servers = Server.where("name LIKE ?", '%'+params[:search]+'%').paginate(:page => params[:page], :per_page => 15).includes(:tags).order("votes DESC, players DESC")
    @serverCount = @servers.count
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
    render 'servers/index'
  end

  def new
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.new
  end

  def create
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    randomKey = ('a'..'z').to_a.shuffle[0,25].join

    #listOfTags = getListOfTags(params)


   # puts "The list of tags has " + listOfTags.count.to_i.to_s + " entries"

    #Do existance checking

    @server = Server.new(server_params.merge(:owner_id => current_user.id, :last_online => Time.now.to_i, :api_key => randomKey))
    begin
      RestClient.get 'http://minecraftpingerapi.herokuapp.com/ping.php?ip='+@server.ip+"&port="+@server.port.to_s
    rescue => e
      puts e.to_s
      flash[:error] = 'The server you are trying to add is not currently online or we are not able to reach it.'

      render 'servers/new' and return
    end
    @server.save
    redirect_to '/user/'
  end

  #def getListOfTags(params)
  #  array = Array.new(30)
  #  unless params[:auth].nil?
  #    puts "Motherfucker"
  #    array.inject(-1, 'Auth')
  #  end
   # array
  #end

  def view
    @server = Server.find(params[:id])
  end

  def vote
    @server = Server.find(params[:id])

    if verify_recaptcha

      vote = Vote.where("server = ? AND ip = ? AND time > UNIX_TIMESTAMP() - 43200", @server.id, request.remote_ip)

      unless vote.nil?
        flash[:error] = "You have already voted for this server within the last 12 hours!"
        redirect_to('/server/'+params[:id]) and return
      end

      flash[:notice] = "You have succesfully voted for " + @server.name
      @server.votes += 1
      @server.save

      @vote = Vote.new(:ip => request.remote_ip, :username => params[:server][:username], :server => @server.id, :time => Time.now.to_i)
      @vote.save
    else
      flash[:error] = "The captcha could not be verified."
    end
    redirect_to('/server/'+params[:id])
  end

  def edit
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])
  end

  def save
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])
    begin
      RestClient.get 'http://minecraftpingerapi.herokuapp.com/ping.php?ip='+@server.ip+"&port="+@server.port.to_s
    rescue
      flash[:error] = 'The server you are trying to add is not currently online or we are not able to reach it.'
      render 'servers/edit' and return
    end
    if @server.update_attributes(server_params)
      redirect_to '/server/' + params[:id] + "/edit"
      return
    else
      redirect_to '/server/' + params[:id] + "/edit"
    end
  end

  def destroy
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])
    @server.destroy!
    redirect_to '/user/'
  end

  def version
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
    params[:version] = params[:version].gsub('_', ".")
    puts params[:version]
    @servers = Server.where("version LIKE ?", '%' + params[:version] + '%').paginate(:page => params[:page], :per_page => 15).includes(:tags).order("votes DESC, players DESC")
    params[:version] = params[:version].gsub('.', "_")
    render 'servers/index'
  end

  def type
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
    type = params[:type]
    @servers = Server.joins(:tags).where("tags.tag = ?", type).paginate(:page => params[:page], :per_page => 15).order("votes DESC, players DESC")
    puts @servers.count.to_s + " fuxkin serbas"
    render 'servers/index'
  end

  def server_params
    params.require(:server).permit(:name, :ip, :port, :description, :banner, :short_description)
  end

end

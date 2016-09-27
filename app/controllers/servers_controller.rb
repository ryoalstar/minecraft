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
    @tags = ["Auth", "Blockhunt", "Capture The Flag", "Cops And Robbers", "Creative", "Economy", "Factions", "Guns", "Hunger Games", "Lobby", "Minigames", "Parkour", "Prison", "PVE", "PVP", "QuakeCraft", "Roleplay", "Skyblock", "Skywars", "Spleef", "Survival", "TNT"]

  end

  def create
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @tags = ["Auth", "Blockhunt", "Capture The Flag", "Cops And Robbers", "Creative", "Economy", "Factions", "Guns", "Hunger Games", "Lobby", "Minigames", "Parkour", "Prison", "PVE", "PVP", "QuakeCraft", "Roleplay", "Skyblock", "Skywars", "Spleef", "Survival", "TNT"]

    randomKey = ('a'..'z').to_a.shuffle[0,25].join


    @server = Server.new(server_params.merge(:owner_id => current_user.id, :last_online => Time.now.to_i, :api_key => randomKey))


    existanceCheck = Server.where("ip = ? AND port = ?", server_params[:ip], server_params[:port]).first

    if !existanceCheck.nil?
      flash[:error] = 'The server you\'re trying to register is already registered with us!'
      render 'servers/new' and return
    end

    tags = params[:server][:tags].to_a
    tags.each do |t|
      Tag.create(:server_id => @server.id, :tag => t)
    end

    params[:server].delete :tags

    begin
      response = RestClient.get 'http://minecraftpingerapi.herokuapp.com/ping.php?ip='+@server.ip+"&port="+@server.port.to_s
      jsonObj = JSON.load(response)
      players = jsonObj['Players'].to_i
      slots = jsonObj['MaxPlayers'].to_i
      version = jsonObj['Version']
      @server.players = players
      @server.slots = slots
      @server.version = version
    rescue => e
      puts e.to_s
      flash[:error] = 'The server you are trying to add is not currently online or we are not able to reach it.'
      render 'servers/new' and return
    end
    @server.save
    redirect_to '/user/'

    if !@server.banner.nil?
      schedule_banner_task(@server.id, @server.banner.url)
    end
  end


  def schedule_banner_task(server_id, url)
    require 'amqp'
    EventMachine.run do
      connection = AMQP.connect('amqp://vocgjaph:YfKSVNj4tlNT4KpfQIxA9sxoif95nlgZ@jaguar.rmq.cloudamqp.com/vocgjaph')
      puts "Connecting to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."

      ch  = AMQP::Channel.new(connection)
      q   = ch.queue("tasks")
      x   = ch.default_exchange
      puts '{"type": "process_banner", "server": '+server_id.to_s+', "url": '+url+'}'
      x.publish '{"type": "process_banner", "server": '+server_id.to_s+', "url": "'+url+'"}', :routing_key => q.name
      EventMachine.add_timer(1) do
        connection.close {
          EventMachine.stop
        }
      end
    end
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

      vote = Vote.where("server = ? AND ip = ? AND UNIX_TIMESTAMP() - time < 43200", @server.id, request.remote_ip).first

      if !vote.nil?
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
    @server = Server.includes(:tags).find(params[:id])
    if @server.owner_id != current_user.id
      redirect_to '/user/' and return
    end
    @tags = ["Auth", "Blockhunt", "Capture The Flag", "Cops And Robbers", "Creative", "Economy", "Factions", "Guns", "Hunger Games", "Lobby", "Minigames", "Parkour", "Prison", "PVE", "PVP", "QuakeCraft", "Roleplay", "Skyblock", "Skywars", "Spleef", "Survival", "TNT"]

  end

  def save

    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.includes(:tags).find(params[:id])
    if @server.nil?
      redirect_to '/user/' and return
    end

    if @server.owner_id != current_user.id
      redirect_to '/user/' and return
    end
    @tags = ["Auth", "Blockhunt", "Capture The Flag", "Cops And Robbers", "Creative", "Economy", "Factions", "Guns", "Hunger Games", "Lobby", "Minigames", "Parkour", "Prison", "PVE", "PVP", "QuakeCraft", "Roleplay", "Skyblock", "Skywars", "Spleef", "Survival", "TNT"]

    begin
      response = RestClient.get 'http://minecraftpingerapi.herokuapp.com/ping.php?ip='+@server.ip+"&port="+@server.port.to_s
      jsonObj = JSON.load(response)
      players = jsonObj['Players'].to_i
      slots = jsonObj['MaxPlayers'].to_i
      version = jsonObj['Version']

      @server.players = players
      @server.slots = slots
      @server.version = version
      @server.save
    rescue
      flash[:error] = 'The server you are trying to add is not currently online or we are not able to reach it.'
      render 'servers/edit' and return
    end

    tags = params[:server][:tags].to_a
    Tag.where("server_id = ?", @server.id).delete_all
    tags.each do |t|
      Tag.create(:server_id => @server.id, :tag => t)
    end

    params[:server].delete :tags

    if @server.update_attributes(server_params)

      redirect_to '/server/' + params[:id] + "/edit"
      return
    else
      redirect_to '/server/' + params[:id] + "/edit"
    end

    if !@server.banner.nil?
      schedule_banner_task(@server.id, @server.banner.url)
    end
  end

  def destroy
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])
    if @server.nil?
      redirect_to '/user/' and return
    end
    if @server.owner_id != current_user.id
      redirect_to '/user/' and return
    end
    @server.destroy!
    redirect_to '/user/'
  end

  def version
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
    @version = params[:version] = params[:version].gsub('_', ".")
    @servers = Server.where("version LIKE ?", '%' + params[:version] + '%').paginate(:page => params[:page], :per_page => 15).includes(:tags).order("votes DESC, players DESC")
    @pretag = "Version " + params[:version]
    params[:version] = params[:version].gsub('.', "_")
    render 'servers/index'
  end

  def vcr
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])
    if @server.nil?
      redirect_to '/user/' and return
    end
    if @server.owner_id != current_user.id
      redirect_to '/user/' and return
    end

    send_data('{
    "website": "https://minecraft-pe-servers.com",
    "check": "https://minecraft-pe-servers.com/api/votes/claim?key='+@server.api_key+'&username={USERNAME}",
    "claim": "https://minecraft-pe-servers.com/api/votes/claim?key='+@server.api_key+'&username={USERNAME}"
}',  :type => 'application/vrc', :filename => 'minecraftpeservers.vcr',
              :disposition => 'attachment', :status => 200)

    return

  end

  def type
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
    type = params[:type]
    @servers = Server.joins(:tags).where("tags.tag = ?", type).paginate(:page => params[:page], :per_page => 15).order("votes DESC, players DESC")
    @pretag = type.humanize
    render 'servers/index'
  end

  def server_params
    params.require(:server).permit(:name, :ip, :port, :description, :banner, :short_description, :tags => [])
  end

end

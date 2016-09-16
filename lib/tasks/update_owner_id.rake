namespace :update_owner_id do

  desc "updates owner id for old servers"
  task :update_tasks => :environment do

    @servers = Server.all
    @servers.each do |s|
      @owner = User.where("username = ?", s.owner).first
      if !@owner.nil?
        puts @owner.id.to_s
        s.owner_id = @owner.id
        s.save
        puts "Updated server " + s.id.to_s
        STDOUT.flush
      else
        STDOUT.flush
      end
    end
  end


end

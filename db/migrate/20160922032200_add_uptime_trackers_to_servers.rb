class AddUptimeTrackersToServers < ActiveRecord::Migration
  def change
    add_column :servers, :pinged_count, :integer
    add_column :servers, :pings_succeeded, :integer
    add_column :servers, :pings_failed, :integer
  end
end

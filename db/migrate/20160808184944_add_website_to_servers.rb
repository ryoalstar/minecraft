class AddWebsiteToServers < ActiveRecord::Migration
  def change
    add_column :servers, :website, :text
  end
end

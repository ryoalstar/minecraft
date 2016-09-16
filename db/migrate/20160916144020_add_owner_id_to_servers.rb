class AddOwnerIdToServers < ActiveRecord::Migration
  def change
    add_column :servers, :owner_id, :integer
  end
end

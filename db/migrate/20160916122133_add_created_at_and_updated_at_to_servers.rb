class AddCreatedAtAndUpdatedAtToServers < ActiveRecord::Migration
  def change
    add_column :servers, :created_at, :datetime
    add_column :servers, :updated_at, :datetime
  end
end

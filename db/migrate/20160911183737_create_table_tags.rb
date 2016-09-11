class CreateTableTags < ActiveRecord::Migration
  def change
    
    create_table :tags do |t|
      t.integer :server_id
      t.string  :tag
    end
  end
end

class CreateBundles < ActiveRecord::Migration
  def self.up
    create_table :bundles do |t|
      t.string :url, :limit => 1000
      t.text :body
      t.datetime :cache_until

      t.timestamps
    end
  end

  def self.down
    drop_table :bundles
  end
end

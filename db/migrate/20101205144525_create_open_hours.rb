class CreateOpenHours < ActiveRecord::Migration
  def self.up
    create_table :open_hours do |t|
      t.integer :shop_id
      t.string  :content

      t.timestamps
    end
  end

  def self.down
    drop_table :open_hours
  end
end


# -*- encoding : utf-8 -*-
class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name, :null => false
      t.string :description, :null => false
      t.string :address, :null => false
      t.string :postcode, :null => false
      t.string :nearest_station, :null => false
      t.string :phone_part_1, :null => false
      t.string :phone_part_2, :null => false
      t.string :phone_part_3, :null => false
      t.string :holiday, :null => false
      t.integer :master_id, :null => false
			t.date :young_start_at
			t.date :prime_start_at
			t.date :middle_start_at
			t.date :old_start_at
			t.date :male_start_at
			t.date :female_start_at
			t.date :all_start_at
			t.integer :young_total_count
			t.integer :prime_total_count
			t.integer :middle_total_count
			t.integer :old_total_count
			t.integer :male_total_count
			t.integer :female_total_count
			t.integer :all_total_count
      t.text :young_followers
      t.text :prime_followers
      t.text :middle_followers
      t.text :old_followers
      t.text :male_followers
      t.text :female_followers
      t.text :all_followers

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end


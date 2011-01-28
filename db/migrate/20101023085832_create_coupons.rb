# -*- encoding : utf-8 -*-
class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :title
      t.string :content
      t.date :start_at
      t.date :end_at
      t.date :activated_at
      t.integer :shop_id
      t.integer :available_count
      t.string  :verification_code
      t.integer :viewed_count, :default => 0
      t.integer :clicked_count, :default => 0
      t.boolean :active, :default => false
      t.boolean :young_targeted, :default => false
      t.boolean :prime_targeted, :default => false
      t.boolean :middle_targeted, :default => false
      t.boolean :old_targeted, :default => false
      t.boolean :all_age_targeted, :default => true
      t.boolean :male_targeted, :default => false
      t.boolean :female_targeted, :default => false
      t.boolean :all_gender_targeted, :default => true

      t.timestamps
    end

    add_index :coupons, :shop_id
  end

  def self.down
    drop_table :coupons
  end
end


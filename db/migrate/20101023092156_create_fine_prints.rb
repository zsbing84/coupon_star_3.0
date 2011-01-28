# -*- encoding : utf-8 -*-
class CreateFinePrints < ActiveRecord::Migration
  def self.up
    create_table :fine_prints do |t|
      t.integer :coupon_id
      t.string  :content
      t.timestamps
    end

    add_index :fine_prints, :coupon_id
  end

  def self.down
    drop_table :fine_prints
  end
end


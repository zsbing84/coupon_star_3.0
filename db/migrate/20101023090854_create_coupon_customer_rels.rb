# -*- encoding : utf-8 -*-
class CreateCouponCustomerRels < ActiveRecord::Migration
  def self.up
    create_table :coupon_customer_rels do |t|
      t.integer :coupon_id, :null => false
      t.integer :customer_id, :null => false
      t.integer :available_count, :null => false
      t.boolean :used, :null => false, :default => false

      t.timestamps
    end

    add_index :coupon_customer_rels, :coupon_id
    add_index :coupon_customer_rels, :customer_id
  end

  def self.down
    drop_table :coupon_customer_rels
  end
end


# -*- encoding : utf-8 -*-
class CreateShopCustomerRels < ActiveRecord::Migration
  def self.up
    create_table :shop_customer_rels do |t|
      t.integer :shop_id, :null => false
      t.integer :customer_id, :null => false

      t.timestamps
    end

    add_index :shop_customer_rels, :shop_id
    add_index :shop_customer_rels, :customer_id
  end

  def self.down
    drop_table :shop_customer_rels
  end
end


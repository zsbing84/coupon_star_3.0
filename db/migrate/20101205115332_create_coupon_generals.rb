class CreateCouponGenerals < ActiveRecord::Migration
  def self.up
    create_table :coupon_generals do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_generals
  end
end

class CreateCouponChartDisplayGenerals < ActiveRecord::Migration
  def self.up
    create_table :coupon_chart_display_generals do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_chart_display_generals
  end
end


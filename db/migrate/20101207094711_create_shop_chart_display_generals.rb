class CreateShopChartDisplayGenerals < ActiveRecord::Migration
  def self.up
    create_table :shop_chart_display_generals do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_chart_display_generals
  end
end


class CreateCouponAnalysisRecords < ActiveRecord::Migration
  def self.up
    create_table :coupon_analysis_records do |t|
      t.integer :coupon_id, :null => false
      t.string :name, :null => false
      t.boolean :is_current, :null => false, :default => false
      t.date :activated_at
      t.date :inactivated_at
      t.text :young_views
      t.text :young_clicks
      t.text :prime_views
      t.text :prime_clicks
      t.text :middle_views
      t.text :middle_clicks
      t.text :old_views
      t.text :old_clicks
      t.text :male_views
      t.text :male_clicks
      t.text :female_views
      t.text :female_clicks
      t.text :all_views
      t.text :all_clicks
      t.integer :viewed_count
      t.integer :clicked_count
      t.timestamps
    end

		add_index :coupon_analysis_records, :activated_at
		add_index :coupon_analysis_records, :inactivated_at
  end

  def self.down
    drop_table :coupon_analysis_records
  end
end


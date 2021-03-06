# -*- encoding : utf-8 -*-
module CouponsHelper

  def get_coupon_age_dist_chart(title, y_title, activated_at, young_data, prime_data, middle_data, old_data, all_data)
    start_point = nil
    if !activated_at.nil?
      start_point = activated_at.to_datetime.to_i
    else
      start_point = 0
    end
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({:renderTo => "age_dist_chart", :marginBottom => 70, :marginRight => 20,
               :defaultSeriesType => "spline",
               :zoomType => 'x'
               })
      f.title({:text => title})
      f.legend({})
      f.x_axis({:type => 'datetime', :tickInterval=> (1000 * 3600 * 24 * 3)})
      f.y_axis({:min => 0, :title => {:text => y_title}})
      f.series(:name=>'24歳未満', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => young_data)
      f.series(:name=>'24歳~44歳', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => prime_data)
      f.series(:name=>'45歳~64歳', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => middle_data)
      f.series(:name=>'65歳以上', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => old_data)
      f.series(:name=>'すべて', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => all_data)
    end
  end

  def get_coupon_gender_dist_chart(title, y_title, activated_at, male_data, female_data, all_data)
    start_point = nil
    if !activated_at.nil?
      start_point = activated_at.to_datetime.to_i
    else
      start_point = 0
    end
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart({:renderTo => "age_dist_chart", :marginBottom => 70, :marginRight => 20,
               :defaultSeriesType => "spline",
               :zoomType => 'x'
               })
      f.title({:text => title})
      f.legend({})
      f.x_axis({:type => 'datetime', :tickInterval=> (1000 * 3600 * 24 * 3)})
      f.y_axis({:min => 0, :title => {:text => y_title}})
      f.series(:name=>'男性', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => male_data)
      f.series(:name=>'女性', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => female_data)
      f.series(:name=>'すべて', :pointInterval=> (1.day * 1000),
               :pointStart => (start_point * 1000),
               :data => all_data)
    end
  end
end


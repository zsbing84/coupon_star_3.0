# -*- encoding : utf-8 -*-
require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
		make_genders
		make_coupon_chart_display_generals
    make_shop_chart_display_generals
		make_masters
    make_shops
		make_coupons
    make_customers
  end
end

def range_rand(min,max)
  min + rand(max-min)
end

def age(dob)
  now = Time.now.utc.to_date
  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
end

def randomDate(params={})
  years_back = params[:year_range] || 5
  latest_year  = params [:year_latest] || 0
  year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
  month = (rand * 12).ceil
  day = (rand * 31).ceil
  series = [date = Time.local(year, month, day)]
  if params[:series]
    params[:series].each do |some_time_after|
      series << series.last + (rand * some_time_after).ceil
    end
    return series
  end
  date
end

def randomGenderId
  n = range_rand(1, 10)
	if (n % 2 == 0)
		return 1
	else
		return 2
	end
end

def make_masters
  Master.create!(:email => "admin@gmail.com",
                 :admin => true,
                 :active => true,
                 :password => "admin",
                 :password_confirmation => "admin")

  3.times do |n|
    email = "master-#{n+1}@railstutorial.org"
    password  = "password"
    Master.create!(:email => email,
	                 :password => password,
	                 :password_confirmation => password,
	                 :active => true)
  end
end

def make_customers
  3.times do |n|
    login = Faker::Name.name
    email = "customer-#{n+1}@railstutorial.org"
    password = "password"
		birthday = randomDate(:year_range => 100, :year_latest => 0)
		gender_id = randomGenderId
    customer = Customer.create!(:email => email,
							                 :password => password,
							                 :password_confirmation => password,
															 :birthday => birthday,
															 :age => age(birthday),
															 :gender_id => gender_id,
															 :active => true)

		Shop.all.each do |shop|
			created_at = shop.created_at.to_date
	    date = Date.today - n
			customer.follow!(shop, date)
			coupon = shop.coupons.first

			(coupon.activated_at..Date.today).each do |date|
				range_rand(1, 5).times do |n|
					customer.view(coupon, date)
				end
			end
	    click_date = coupon.start_at + rand((Date.today - coupon.start_at).to_i).days
			customer.click(coupon, click_date)
		end
  end
end

def make_genders
    Gender.create!(:name => "男性")
    Gender.create!(:name => "女性")
end

def make_coupon_chart_display_generals
    CouponChartDisplayGeneral.create!(:name => "閲覧数")
    CouponChartDisplayGeneral.create!(:name => "利用数")
end

def make_shop_chart_display_generals
    ShopChartDisplayGeneral.create!(:name => "最近1週間")
    ShopChartDisplayGeneral.create!(:name => "最近1ヶ月間")
    ShopChartDisplayGeneral.create!(:name => "最近3ヶ月間")
end

def make_shops
  index = 0
	Master.limit(3).offset(1).each do |master|
    index = index + 1
    name = "中華料理五十番-#{index}"
    description = "本格の上海料理"
    address = "神奈川県海老名市中央2-10-23"
    phone_part_1 = "046"
    phone_part_2 = "233"
    phone_part_3 = "0050"
		holiday = "月曜日"
		nearest_station = "JR中央線・山手線「新宿駅」より徒歩3分"
		postcode = "1600000"
    shop = master.shops.create!(:name => name,
											         :description => description,
											         :address => address,
											         :phone_part_1 => phone_part_1,
	                             :phone_part_2 => phone_part_2,
	                             :phone_part_3 => phone_part_3,
											         :holiday => holiday,
											         :postcode => postcode,
											         :nearest_station => nearest_station)

    datetime = (shop.created_at.to_date - 240).to_datetime
    shop.update_attribute(:created_at, datetime)
    start_at = shop.created_at.to_date
    shop.update_attributes(:young_start_at => start_at,
                          :prime_start_at => start_at,
                          :middle_start_at => start_at,
                          :old_start_at => start_at,
                          :male_start_at => start_at,
                          :female_start_at => start_at,
                          :all_start_at => start_at,
                          :young_total_count => 0,
                          :prime_total_count => 0,
                          :middle_total_count => 0,
                          :old_total_count => 0,
                          :male_total_count => 0,
                          :female_total_count => 0,
                          :all_total_count => 0,
                          :young_followers => get_init_followers_str(),
                          :prime_followers => get_init_followers_str(),
                          :middle_followers => get_init_followers_str(),
                          :old_followers => get_init_followers_str(),
                          :male_followers => get_init_followers_str(),
                          :female_followers => get_init_followers_str(),
                          :old_followers => get_init_followers_str(),
                          :all_followers => get_init_followers_str())
  end
end

def make_coupons
	index = 0;
  Shop.all.each do |shop|
		index = index + 1
    3.times do |n|
    	title = "五十番餃子一皿無料-#{index}-#{n}"
    	content = "五十番餃子一皿を無料サービス致します。"
    	start_at = Date.today + 1.day
    	end_at = Date.today + 7.days
      verification_code = "1234"
			available_count = 2
    	coupon = shop.coupons.create!(:title => title,
																		:content => content,
																		:start_at => start_at,
																		:end_at => end_at,
																		:verification_code => verification_code,
																		:available_count => available_count)

      CouponAnalysisRecord.create!(:coupon_id => coupon.id,
			                             :is_current => true,
			                             :name => "現在利用中")
			activated_at = start_at - 7.days
			Coupon.activate!(coupon, activated_at)
	  end
  end
end

def get_init_followers_str
  array = []
  (0..179).each do |index|
    array << 0
  end
  convert_array_to_string(array)
end

def convert_array_to_string(array)
  array.join(', ')
end


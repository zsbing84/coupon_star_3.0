
# -*- encoding : utf-8 -*-
class Customer < ActiveRecord::Base

	acts_as_authentic do |c|
    c.login_field = 'email'
  end

	has_many :shops, :through => :shop_customer_rels, :source => :shop
  has_many :coupons, :through => :coupon_customer_rels, :source => :coupon

  has_many :shop_customer_rels, :foreign_key => "customer_id",
                             	  :dependent => :destroy
	has_many :coupon_customer_rels, :foreign_key => "customer_id",
                           				:dependent => :destroy

  validates_presence_of :password
  validates_presence_of :gender_id
	validates_date :birthday

	def self.activate!(customer)
    customer.update_attribute(:active, true)
  end

	def following?(shop)
    shop_customer_rels.find_by_shop_id(shop)
  end

  def follow!(shop, date)
    if !self.following?(shop)
      shop_customer_rels.create!(:shop_id => shop.id)
      shop.add_follower_to_analysis(self, date)
		  shop.coupons.each do |coupon|
		    if coupon.active? && !has_used_coupon?(coupon)
			    coupon_customer_rels.create!(:coupon_id => coupon.id, :available_count => coupon.available_count)
        end
		  end
    end
  end

	def unfollow!(shop, date)
		shop.coupons.where(:active => true).each do |coupon|
		  relationship = coupon_customer_rels.find_by_coupon_id(coupon.id)
      if !relationship.nil? && !self.has_used_coupon?(coupon)
        relationship.destroy
      end
		end
		shop_customer_rels.find_by_shop_id(shop).destroy
    shop.delete_follower_from_analysis(self, date)
  end

  def view(coupon, date)
    viewed_count = coupon.viewed_count + 1
    coupon.update_attribute(:viewed_count, viewed_count)
		increase_analysis_views_str(coupon, date)
  end

  def click(coupon, date)
    rel = coupon_customer_rels.find_by_coupon_id(coupon)
		if !rel.nil?
			if rel.available_count > 0
				available_count = rel.available_count - 1
		    rel.update_attribute(:available_count, available_count)
		    clicked_count = coupon.clicked_count + 1
		    coupon.update_attribute(:clicked_count, clicked_count)
				increase_analysis_clicks_str(coupon, date)
			end
		end
  end

  def get_coupons
    coupons = []
    coupon_customer_rels.where("available_count > ?", 0).each do |rel|
      if self.has_coupon?(rel.coupon)
        coupons << rel.coupon
      end
    end
    return coupons
  end

  def has_coupon?(coupon)
    if !self.following?(coupon.shop)
      return false
    else
      rel = coupon_customer_rels.find_by_coupon_id(coupon)
      if rel.nil? || rel.available_count == 0
        return false
      else
        return true
      end
    end
  end

  def has_used_coupon?(coupon)
    rel = coupon_customer_rels.find_by_coupon_id(coupon.id)
    if rel.nil? || rel.available_count == coupon.available_count
			return false
		else
			return true
		end
  end

	def increase_analysis_views_str(coupon, date)
		record = CouponAnalysisRecord.where("coupon_id = ? AND is_current = ?", coupon.id, true).first
    index = date - record.activated_at
    age = self.age
    gender_id = self.gender_id

		if age < 24
			array = convert_string_to_array(record.young_views)
      array[index] = array[index] + 1
      young_views = convert_array_to_string(array)
      record.update_attributes(:young_views => young_views)
		elsif age >= 24 && age < 45
			array = convert_string_to_array(record.prime_views)
      array[index] = array[index] + 1
      prime_views = convert_array_to_string(array)
      record.update_attributes(:prime_views => prime_views)
		elsif age >= 45 && age < 65
			array = convert_string_to_array(record.middle_views)
      array[index] = array[index] + 1
      middle_views = convert_array_to_string(array)
      record.update_attributes(:middle_views => middle_views)
		elsif age >= 65
			array = convert_string_to_array(record.old_views)
      array[index] = array[index] + 1
      old_views = convert_array_to_string(array)
      record.update_attributes(:old_views => old_views)
		end

    if gender_id == 1
      array = convert_string_to_array(record.male_views)
      array[index] = array[index] + 1
      male_views = convert_array_to_string(array)
      record.update_attributes(:male_views => male_views)
    elsif gender_id == 2
      array = convert_string_to_array(record.female_views)
      array[index] = array[index] + 1
      female_views = convert_array_to_string(array)
      record.update_attributes(:female_views => female_views)
    end

    array = convert_string_to_array(record.all_views)
    array[index] = array[index] + 1
    all_views = convert_array_to_string(array)
    record.update_attributes(:all_views => all_views)
	end

  def increase_analysis_clicks_str(coupon, date)
		record = CouponAnalysisRecord.where("coupon_id = ? AND is_current = ?", coupon.id, true).first
    index = date - record.activated_at
    age = self.age
    gender_id = self.gender_id

		if age <= 24
			array = convert_string_to_array(record.young_clicks)
      array[index] = array[index] + 1
      young_clicks = convert_array_to_string(array)
      record.update_attributes(:young_clicks => young_clicks)
		elsif age > 24 && age <= 44
			array = convert_string_to_array(record.prime_clicks)
      array[index] = array[index] + 1
      prime_clicks = convert_array_to_string(array)
      record.update_attributes(:prime_clicks => prime_clicks)
		elsif age > 45 && age <= 64
			array = convert_string_to_array(record.middle_clicks)
      array[index] = array[index] + 1
      middle_clicks = convert_array_to_string(array)
      record.update_attributes(:middle_clicks => middle_clicks)
		elsif age > 65
			array = convert_string_to_array(record.old_clicks)
      array[index] = array[index] + 1
      old_clicks = convert_array_to_string(array)
      record.update_attributes(:old_clicks => old_clicks)
		end

    if gender_id == 1
      array = convert_string_to_array(record.male_clicks)
      array[index] = array[index] + 1
      male_clicks = convert_array_to_string(array)
      record.update_attributes(:male_clicks => male_clicks)
    elsif gender_id == 2
      array = convert_string_to_array(record.female_clicks)
      array[index] = array[index] + 1
      female_clicks = convert_array_to_string(array)
      record.update_attributes(:female_clicks => female_clicks)
    end

    array = convert_string_to_array(record.all_clicks)
    array[index] = array[index] + 1
    all_clicks = convert_array_to_string(array)
    record.update_attributes(:all_clicks => all_clicks)
	end

  def convert_array_to_string(array)
    array.join(', ')
  end

	def convert_string_to_array(string)
		string.split(',').map(&:to_i)
  end

  def new_random_password
    self.password= Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")[0,6]
    self.password_confirmation = self.password
  end

end


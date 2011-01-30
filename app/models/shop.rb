# -*- encoding : utf-8 -*-
class Shop < ActiveRecord::Base
	has_many :shop_customer_rels, :foreign_key => "shop_id",
                         		  	:dependent => :destroy
	has_many :customers, :through => :shop_customer_rels, :source => :customer
	has_many :coupons, :dependent => :destroy
  has_many :open_hours, :foreign_key => "shop_id",
                        :dependent => :destroy
	belongs_to :master

  has_attached_file :photo, :styles => { :normal =>"390x300#", :small => "80x70#", :thumb =>"80x60>"}
  validates :name, :presence => true, :length => { :maximum => 20 }, :uniqueness => true
  validates :description, :presence => true, :length => {:maximum => 160 }
  validates :postcode, :presence => true, :length => {:minimum => 7, :maximum => 7 }, :numericality => true
  validates :nearest_station, :presence => true, :length => {:maximum => 30 }
  validates :phone_part_1, :presence => true, :numericality => true, :length => { :maximum => 4 }
  validates :phone_part_2, :presence => true, :numericality => true, :length => { :maximum => 4 }
  validates :phone_part_3, :presence => true, :numericality => true, :length => { :maximum => 4 }
  validates :address, :presence => true, :length => { :maximum => 20 }
  validates :holiday, :presence => true, :length => { :maximum => 20 }
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  accepts_nested_attributes_for :open_hours, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  searchable do
    text :name, :default_boost => 2
    text :description
  end

	def get_coupons
		@coupons = []
    if signed_in_customer?
      current_customer.get_coupons.each do |coupon|
        if coupon.shop_id == @shop.id
          @coupons << coupon
        end
      end
    elsif signed_in_master?
      current_master.get_coupons.each do |coupon|
        if coupon.shop_id == @shop.id
          @coupons << coupon
        end
      end
    end

		return coupons
	end

  def get_analysis_start_at(duration_id)
    start_at = self.young_start_at
    created_at = self.created_at.to_date
    dist = (Date.today - start_at).to_i
    if start_at > created_at
      if duration_id == 1
        6.days.ago
		  elsif duration_id == 2
        30.days.ago
		  elsif duration_id == 3
        90.days.ago
		  elsif duration_id == 4
        180.days.ago
		  end
    else
      if duration_id == 1
        if dist < 6
          Date.today - dist
        else
          Date.today - 6
        end
		  elsif duration_id == 2
        if dist < 29
          Date.today - dist
        else
          Date.today - 29
        end
		  elsif duration_id == 3
        if dist < 89
          Date.today - dist
        else
          Date.today - 89
        end
		  elsif duration_id == 4
        if dist < 179
          Date.today - dist
        else
          Date.today - 179
        end
		  end
    end
  end

  def get_analysis_days_interval(duration_id)
    if duration_id == 1
      1
		elsif duration_id == 2
      5
		elsif duration_id == 3
      20
		elsif duration_id == 4
      30
		end
  end

  def get_analysis_data(duration_id, serie)
		update_follower_of_analysis()

		array = []
		total_count = 0
		start_at = nil
		if serie == "young"
			array = convert_string_to_array(self.young_followers)
			total_count = self.young_total_count
			start_at = self.young_start_at
		elsif serie == "prime"
			array = convert_string_to_array(self.prime_followers)
			total_count = self.prime_total_count
			start_at = self.prime_start_at
		elsif serie == "middle"
			array = convert_string_to_array(self.middle_followers)
			total_count = self.middle_total_count
			start_at = self.middle_start_at
		elsif serie == "old"
			array = convert_string_to_array(self.old_followers)
			total_count = self.old_total_count
			start_at = self.old_start_at
		elsif serie == "male"
			array = convert_string_to_array(self.male_followers)
			total_count = self.male_total_count
			start_at = self.male_start_at
		elsif serie == "female"
			array = convert_string_to_array(self.female_followers)
			total_count = self.female_total_count
			start_at = self.female_start_at
		elsif serie == "all"
			array = convert_string_to_array(self.all_followers)
			total_count = self.all_total_count
			start_at = self.all_start_at
		end

    dist = (Date.today - start_at).to_i + 1
    created_at = self.created_at.to_date
    if start_at > created_at
      if duration_id == 1
        period = 7
		  elsif duration_id == 2
        period = 30
		  elsif duration_id == 3
        period = 90
		  elsif duration_id == 4
        period = 180
		  end
    else
      if duration_id == 1
        if dist < 7
          period = dist
        else
          period = 7
        end
		  elsif duration_id == 2
        if dist < 30
          period = dist
        else
          period = 30
        end
		  elsif duration_id == 3
        if dist < 90
          period = dist
        else
          period = 90
        end
		  elsif duration_id == 4
        if dist < 180
          period = dist
        else
          period = 180
        end
		  end
    end

    sum = total_count
    index = -1
    result = []
		array.map do |value|
		  sum += value
		  index = index + 1
		  if index > dist - period - 1 && index < dist
        result << sum
      end
    end

    return result
	end

	def update_follower_of_analysis
		date = Date.today

		total_count = update_analysis_total_count(self.young_total_count, self.young_followers, self.young_start_at, date)
    self.update_attribute(:young_total_count, total_count)
		str = update_analysis_followers(self.young_followers, self.young_start_at, date)
    self.update_attribute(:young_followers, str)
    start_at = update_analysis_start_at(self.young_start_at, date)
    self.update_attribute(:young_start_at, start_at)

		total_count = update_analysis_total_count(self.prime_total_count, self.prime_followers, self.prime_start_at, date)
    self.update_attribute(:prime_total_count, total_count)
 		str = update_analysis_followers(self.prime_followers, self.prime_start_at, date)
    self.update_attribute(:prime_followers, str)
		start_at = update_analysis_start_at(self.prime_start_at, date)
    self.update_attribute(:prime_start_at, start_at)

		total_count = update_analysis_total_count(self.middle_total_count, self.middle_followers, self.middle_start_at, date)
    self.update_attribute(:middle_total_count, total_count)
		str = update_analysis_followers(self.middle_followers, self.middle_start_at, date)
    self.update_attribute(:middle_followers, str)
		start_at = update_analysis_start_at(self.middle_start_at, date)
    self.update_attribute(:middle_start_at, start_at)

		total_count = update_analysis_total_count(self.old_total_count, self.old_followers, self.old_start_at, date)
    self.update_attribute(:old_total_count, total_count)
		str = update_analysis_followers(self.old_followers, self.old_start_at, date)
    self.update_attribute(:old_followers, str)
		start_at = update_analysis_start_at(self.old_start_at, date)
    self.update_attribute(:old_start_at, start_at)

		total_count = update_analysis_total_count(self.male_total_count, self.male_followers, self.male_start_at, date)
    self.update_attribute(:male_total_count, total_count)
		str = update_analysis_followers(self.male_followers, self.male_start_at, date)
    self.update_attribute(:male_followers, str)
		start_at = update_analysis_start_at(self.male_start_at, date)
    self.update_attribute(:male_start_at, start_at)

		total_count = update_analysis_total_count(self.female_total_count, self.female_followers, self.female_start_at, date)
    self.update_attribute(:female_total_count, total_count)
		str = update_analysis_followers(self.female_followers, self.female_start_at, date)
    self.update_attribute(:female_followers, str)
		start_at = update_analysis_start_at(self.female_start_at, date)
    self.update_attribute(:female_start_at, start_at)

		total_count = update_analysis_total_count(self.all_total_count, self.all_followers, self.all_start_at, date)
	  self.update_attribute(:all_total_count, total_count)
		str = update_analysis_followers(self.all_followers, self.all_start_at, date)
	  self.update_attribute(:all_followers, str)
		start_at = update_analysis_start_at(self.all_start_at, date)
	  self.update_attribute(:all_start_at, start_at)
	end

  def add_follower_to_analysis(customer, date)
    age = customer.age
    gender_id = customer.gender_id

    if age < 24
			total_count = update_analysis_total_count(self.young_total_count, self.young_followers, self.young_start_at, date)
      self.update_attribute(:young_total_count, total_count)
      str = increase_analysis_followers(self.young_followers, self.young_start_at, date)
      self.update_attribute(:young_followers, str)
			start_at = update_analysis_start_at(self.young_start_at, date)
      self.update_attribute(:young_start_at, start_at)
    elsif age >= 24 && age < 45
			total_count = update_analysis_total_count(self.prime_total_count, self.prime_followers, self.prime_start_at, date)
      self.update_attribute(:prime_total_count, total_count)
      str = increase_analysis_followers(self.prime_followers, self.prime_start_at, date)
      self.update_attribute(:prime_followers, str)
			start_at = update_analysis_start_at(self.prime_start_at, date)
      self.update_attribute(:prime_start_at, start_at)
    elsif age >= 45 && age < 65
			total_count = update_analysis_total_count(self.middle_total_count, self.middle_followers, self.middle_start_at, date)
      self.update_attribute(:middle_total_count, total_count)
      str = increase_analysis_followers(self.middle_followers, self.middle_start_at, date)
      self.update_attribute(:middle_followers, str)
			start_at = update_analysis_start_at(self.middle_start_at, date)
      self.update_attribute(:middle_start_at, start_at)
    elsif age >= 65
			total_count = update_analysis_total_count(self.old_total_count, self.old_followers, self.old_start_at, date)
      self.update_attribute(:old_total_count, total_count)
      str = increase_analysis_followers(self.old_followers, self.old_start_at, date)
      self.update_attribute(:old_followers, str)
			start_at = update_analysis_start_at(self.old_start_at, date)
      self.update_attribute(:old_start_at, start_at)
    end

    if gender_id == 1
			total_count = update_analysis_total_count(self.male_total_count, self.male_followers, self.male_start_at, date)
      self.update_attribute(:male_total_count, total_count)
      str = increase_analysis_followers(self.male_followers, self.male_start_at, date)
      self.update_attribute(:male_followers, str)
			start_at = update_analysis_start_at(self.male_start_at, date)
      self.update_attribute(:male_start_at, start_at)
    elsif gender_id == 2
			total_count = update_analysis_total_count(self.female_total_count, self.female_followers, self.female_start_at, date)
      self.update_attribute(:female_total_count, total_count)
      str = increase_analysis_followers(self.female_followers, self.female_start_at, date)
      self.update_attribute(:female_followers, str)
			start_at = update_analysis_start_at(self.female_start_at, date)
      self.update_attribute(:female_start_at, start_at)
    end

		total_count = update_analysis_total_count(self.all_total_count, self.all_followers, self.all_start_at, date)
	  self.update_attribute(:all_total_count, total_count)
    str = increase_analysis_followers(self.all_followers, self.all_start_at, date)
	  self.update_attribute(:all_followers, str)
		start_at = update_analysis_start_at(self.all_start_at, date)
	  self.update_attribute(:all_start_at, start_at)
  end

  def delete_follower_from_analysis(customer, date)
    age = customer.age
    gender_id = customer.gender_id

    if age <= 24
			total_count = update_analysis_total_count(self.young_total_count, self.young_followers, self.young_start_at, date)
      self.update_attribute(:young_total_count, total_count)
      str = decrease_analysis_followers(self.young_followers, self.young_start_at, date)
      self.update_attribute(:young_followers, str)
			start_at = update_analysis_start_at(self.young_start_at, date)
      self.update_attribute(:young_start_at, start_at)
    elsif age > 24 && age <= 44
			total_count = update_analysis_total_count(self.prime_total_count, self.prime_followers, self.prime_start_at, date)
      self.update_attribute(:prime_total_count, total_count)
      str = decrease_analysis_followers(self.prime_followers, self.prime_start_at, date)
      self.update_attribute(:prime_followers, str)
			start_at = update_analysis_start_at(self.prime_start_at, date)
      self.update_attribute(:prime_start_at, start_at)
    elsif age > 44 && age <= 64
			total_count = update_analysis_total_count(self.middle_total_count, self.middle_followers, self.middle_start_at, date)
      self.update_attribute(:middle_total_count, total_count)
      str = decrease_analysis_followers(self.middle_followers, self.middle_start_at, date)
      self.update_attribute(:middle_followers, str)
			start_at = update_analysis_start_at(self.middle_start_at, date)
      self.update_attribute(:middle_start_at, start_at)
    elsif age > 65
			total_count = update_analysis_total_count(self.old_total_count, self.old_followers, self.old_start_at, date)
      self.update_attribute(:old_total_count, total_count)
      str = decrease_analysis_followers(self.old_followers, self.old_start_at, date)
      self.update_attribute(:old_followers, str)
			start_at = update_analysis_start_at(self.old_start_at, date)
      self.update_attribute(:old_start_at, start_at)
    end

    if gender_id == 1
			total_count = update_analysis_total_count(self.male_total_count, self.male_followers, self.male_start_at, date)
      self.update_attribute(:male_total_count, total_count)
      str = decrease_analysis_followers(self.male_followers, self.male_start_at, date)
      self.update_attribute(:male_followers, str)
			start_at = update_analysis_start_at(self.male_start_at, date)
      self.update_attribute(:male_start_at, start_at)
    elsif gender_id == 2
			total_count = update_analysis_total_count(self.female_total_count, self.female_followers, self.female_start_at, date)
      self.update_attribute(:female_total_count, total_count)
      str = decrease_analysis_followers(self.female_followers, self.female_start_at, date)
      self.update_attribute(:female_followers, str)
			start_at = update_analysis_start_at(self.female_start_at, date)
      self.update_attribute(:female_start_at, start_at)
    end

		total_count = update_analysis_total_count(self.all_total_count, self.all_followers, self.all_start_at, date)
	  self.update_attribute(:all_total_count, total_count)
    str = decrease_analysis_followers(self.all_followers, self.all_start_at, date)
	  self.update_attribute(:all_followers, str)
		start_at = update_analysis_start_at(self.all_start_at, date)
	  self.update_attribute(:all_start_at, start_at)
  end

  def update_analysis_followers(str, start_at, date)
    array = convert_string_to_array(str)

		dist = (date - start_at).to_i
		if dist >= 180
			(180..dist).each do |index|
	    	array = insert_into_rotate_array(array, 0)
	    end
		end

    convert_array_to_string(array)
  end

  def increase_analysis_followers(str, start_at, date)
    array = convert_string_to_array(str)

		dist = (date - start_at).to_i
		if dist < 180
			array[dist] = array[dist] + 1
    elsif dist == 180
			array = insert_into_rotate_array(array, 1)
		else
			(180..(dist-1)).each do |index|
	    	array = insert_into_rotate_array(array, 0)
	    end
			array = insert_into_rotate_array(array, 1)
		end

    convert_array_to_string(array)
  end

  def decrease_analysis_followers(str, start_at, date)
    array = convert_string_to_array(str)

		dist = (date - start_at).to_i
		if dist < 180
			array[dist] = array[dist] - 1
    elsif dist == 180
			array = insert_into_rotate_array(array, -1)
		else
			(180..(dist-1)).each do |index|
	    	array = insert_into_rotate_array(array, 0)
	    end
			array = insert_into_rotate_array(array, -1)
		end

    convert_array_to_string(array)
  end

	def update_analysis_start_at(start_at, date)
		if (date - start_at).to_i > 179
			dist = (date - start_at).to_i - 179
    else
      dist = 0
    end

		return start_at + dist
  end

	def update_analysis_total_count(total_count, str, start_at, date)
		array = convert_string_to_array(str)
    dist = 0
		if date - start_at > 179
		  if date - start_at - 180 > 179
		    max_limit = 179
      else
        max_limit = date - start_at - 180
      end
			(0..max_limit).each do |index|
				dist += array[index]
			end
		else
			dist = 0
		end

		return total_count + dist
  end

	def insert_into_rotate_array(array, value)
		result = []
		(0..(array.count-2)).each do |index|
			result[index] = array[index+1]
		end

		result[array.count-1] = value
		return result
	end

  def convert_string_to_array(string)
		if string.nil?
			return nil
		else
			return string.split(',').map(&:to_i)
		end
  end

  def convert_array_to_string(array)
    array.join(', ')
  end

end


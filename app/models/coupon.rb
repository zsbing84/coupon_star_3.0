# -*- encoding : utf-8 -*-
class Coupon < ActiveRecord::Base
  belongs_to :shop
	has_many :customers, :through => :coupon_customer_rels, :source => :customer
  has_many :coupon_customer_rels, :foreign_key => "coupon_id",
                             				:dependent => :destroy
  has_many :fine_prints, :foreign_key => "coupon_id",
                          :dependent => :destroy
  has_many :coupon_analysis_records, :foreign_key => "coupon_id",
                              :dependent => :destroy

  has_attached_file :photo, :styles => { :normal =>"390x300#", :small => "80x70#", :thumb =>"80x60>"}
  validates :title, :presence => true, :length => { :maximum => 20 }, :uniqueness => true
  validates :content, :presence => true, :length => { :maximum => 160 }
	validates_date :start_at, :on_or_after => :today, :on_or_after_message => "に本日または本日より後の日を選択してください。"
	validates_date :start_at, :on_or_before => :end_at, :on_or_before_message => "に利用期限日または利用期限日より前の日を選択してください。"
	validates_date :end_at, :on_or_after => :today, :on_or_after_message => "に本日または本日より後の日を選択してください。"
	validates_date :end_at, :on_or_after => :start_at, :on_or_after_message => "に利用開始日または開始日より後の日を選択してください。"

  validates :start_at, :presence => true
  validates :end_at, :presence => true
  validates :shop_id, :presence => true
  validates :verification_code, :presence => true, :length => { :minimum => 4, :maximum => 4 }, :numericality => true
  validates_numericality_of :available_count, :presence => true, :less_than_or_equal_to => 10, :greater_than => 0
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  accepts_nested_attributes_for :fine_prints, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  searchable do
    text :title, :default_boost => 2
    text :content
  end

	def self.activate!(coupon, date)
    coupon.shop.customers.each do |customer|
      if is_age_sufficient(coupon, customer) && is_gender_sufficient(coupon, customer)
        CouponCustomerRel.create!(:coupon_id => coupon.id,
                                   :customer_id => customer.id,
                                   :available_count => coupon.available_count)
        rel = ShopCustomerRel.where("shop_id = ? AND customer_id = ?", coupon.shop.id, customer.id).first
        if customer.receive_notice?
          CustomerMailer.delay.deliver_new_coupon_instructions(customer, self)
        end
      end
    end

		init_str = get_init_str(coupon, date)
	  record = CouponAnalysisRecord.where("coupon_id = ? AND is_current = ?", coupon.id, true).first
		record.update_attributes(:activated_at => date,
														 :young_views => init_str,
		                         :young_clicks => init_str,
		                         :prime_views => init_str,
		                         :prime_clicks => init_str,
		                         :middle_views => init_str,
		                         :middle_clicks => init_str,
		                         :old_views => init_str,
		                         :old_clicks => init_str,
		                         :male_views => init_str,
		                         :male_clicks => init_str,
		                         :female_views => init_str,
		                         :female_clicks => init_str,
                             :all_views => init_str,
		                         :all_clicks => init_str)

    coupon.update_attributes(:active => true,
                             :activated_at => date)
	end

	def self.inactivate(coupon)
	  if coupon.start_at > Date.today
	    name = "#{coupon.start_at} ~ #{coupon.start_at}"
    else
	    name = "#{coupon.start_at} ~ #{Date.today}"
    end

    record = CouponAnalysisRecord.where("coupon_id = ? AND is_current = ?", coupon.id, true).first
    CouponAnalysisRecord.create!(:coupon_id => coupon.id,
                           :is_current => false,
                           :name => name,
                           :activated_at => record.activated_at,
                           :young_views => get_analysis_str(record.young_views, coupon),
                           :young_clicks => get_analysis_str(record.young_clicks, coupon),
                           :prime_views => get_analysis_str(record.prime_views, coupon),
                           :prime_clicks => get_analysis_str(record.prime_clicks, coupon),
                           :middle_views => get_analysis_str(record.middle_views, coupon),
                           :middle_clicks => get_analysis_str(record.middle_clicks, coupon),
                           :old_views => get_analysis_str(record.old_views, coupon),
                           :old_clicks => get_analysis_str(record.old_clicks, coupon),
                           :male_views => get_analysis_str(record.male_views, coupon),
                           :male_clicks => get_analysis_str(record.male_clicks, coupon),
                           :female_views => get_analysis_str(record.female_views, coupon),
                           :female_clicks => get_analysis_str(record.female_clicks, coupon),
                           :all_views => get_analysis_str(record.all_views, coupon),
                           :all_clicks => get_analysis_str(record.all_clicks, coupon))

		record.update_attributes(:activated_at => nil,
														 :young_views => nil,
		                         :young_clicks => nil,
		                         :prime_views => nil,
		                         :prime_clicks => nil,
		                         :middle_views => nil,
		                         :middle_clicks => nil,
		                         :old_views => nil,
		                         :old_clicks => nil,
		                         :male_views => nil,
		                         :male_clicks => nil,
		                         :female_views => nil,
		                         :female_clicks => nil,
                             :all_views => nil,
		                         :all_clicks => nil)

    CouponCustomerRel.where("coupon_id = ?", coupon.id).each do |rel|
      rel.destroy
    end

    coupon.update_attributes(:viewed_count => 0,
                             :clicked_count => 0,
                             :active => false,
                             :activated_at => nil)
	end

	def self.get_init_str(coupon, date)
		array = []
		(date..coupon.end_at).each do |date|
			array << 0
		end
		array.join(',')
	end

	def self.get_analysis_str(string, coupon)
		if coupon.end_at == Date.today || string.nil?
			return string
    else
			s_array = convert_string_to_array(string)
			t_array = []
			index = 0
			(coupon.activated_at..Date.today).each do |date|
				index = index + 1
				t_array[index] = s_array[index]
			end
			t_array.join(',')
		end
	end

  def self.is_age_sufficient(coupon, customer)
    age = customer.age

    if coupon.all_age_targeted == true
      return true
    end

    if coupon.young_targeted == true
      if age < 24
        return true
      end
    end

    if coupon.prime_targeted == true
      if age >= 24 && age < 45
        return true
      end
    end

    if coupon.middle_targeted == true
      if age >= 45 && age < 65
        return true
      end
    end

    if coupon.old_targeted == true
      if age >= 65
        return true
      end
    end

    return false
  end

  def self.is_gender_sufficient(coupon, customer)
    gender_id = customer.gender_id

    if coupon.all_gender_targeted == true
      return true
    end

    if coupon.male_targeted == true
      if gender_id == 0
        return true
      end
    end

    if coupon.female_targeted == true
      if gender_id == 1
        return true
      end
    end

    return false
  end

  def self.convert_array_to_string(array)
    array.join(', ')
  end

	def self.convert_string_to_array(string)
		string.split(',').map(&:to_i)
  end

end


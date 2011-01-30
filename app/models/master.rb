# -*- encoding : utf-8 -*-

class Master < ActiveRecord::Base

	acts_as_authentic do |c|
    c.login_field = 'email'
  end

	has_many :shops, :dependent => :destroy

  searchable do
    text :email, :default_boost => 2
  end

	def self.activate!(master)
    master.update_attribute(:active, true)
  end

	def get_shops
    if self.admin
			return Shop.all
		else
			return self.shops
		end
  end

	def get_coupons
    if self.admin
			return Coupon.all
		else
			@coupons = []
      self.shops.each do |shop|
        shop.coupons.each do |coupon|
          @coupons << coupon
        end
      end
			return @coupons
		end
  end

	def has_coupon?(coupon)
    if coupon.shop.master.id == self.id
			return true
		else
			return false
		end
  end

	def has_shop?(shop)
    if shop.master.id == self.id
			return true
		else
			return false
		end
  end

  def new_random_password
    password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--")[0,6]
    return password
  end

end


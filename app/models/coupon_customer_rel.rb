# -*- encoding : utf-8 -*-
class CouponCustomerRel < ActiveRecord::Base
	belongs_to :coupon
  belongs_to :customer
end


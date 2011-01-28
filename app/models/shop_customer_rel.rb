# -*- encoding : utf-8 -*-
class ShopCustomerRel < ActiveRecord::Base
	belongs_to :shop, :class_name => "Shop"
  belongs_to :customer, :class_name => "Customer"

  validates :shop_id, :presence => true
  validates :customer_id, :presence => true
end


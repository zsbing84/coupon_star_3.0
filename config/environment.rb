# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CouponStar::Application.initialize!

WillPaginate::ViewHelpers.pagination_options[:prev_label] = '前の10件へ'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '次の10件へ'


USING_SUNSPOT_RAILS = true

# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe CouponSearch do
  it "should be valid" do
    CouponSearch.new.should be_valid
  end
end

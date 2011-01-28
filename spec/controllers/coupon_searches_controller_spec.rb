# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe CouponSearchesController do
  fixtures :all
  render_views

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    CouponSearch.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    CouponSearch.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(coupon_search_url(assigns[:coupon_search]))
  end
  
  it "show action should render show template" do
    get :show, :id => CouponSearch.first
    response.should render_template(:show)
  end
end

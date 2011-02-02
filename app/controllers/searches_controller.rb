# -*- encoding : utf-8 -*-
class SearchesController < ApplicationController
	trans_sid
	before_filter :require_master, :only => [:masters_search, :customers_search, :coupon_analysis_records_search]
	before_filter :require_master_or_customer, :only => [:coupons_search, :shops_search]

  def coupons_search
    if params[:keywords] != ""
      @coupons = Sunspot.search(Coupon) do
        keywords(params[:keywords])
      end
      @coupons = @coupons.results
    else
      @coupons = Coupon.all
    end

		results = []
		if request.mobile?
			@coupons.each do |coupon|
				if current_customer.has_coupon?(coupon)
					results << coupon
				end
			end
		elsif admin_master?
			results = @coupons
		else
			@coupons.each do |coupon|
				if current_master.has_coupon?(coupon)
					results << coupon
				end
			end
		end

		@coupons = results
    @count = @coupons.count
    if request.mobile?
      @coupons = @coupons.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 10
    end

    @header_coupons = true;
    @coupons_search = true;
    render "/coupons/index"
  end

  def shops_search
    if params[:keywords] != ""
      @shops = Sunspot.search(Shop) do
        keywords(params[:keywords])
      end
      @shops = @shops.results
    else
      @shops = Shop.all
    end

		results = []
		if request.mobile?
			@shops.each do |shop|
				if current_customer.following?(shop)
					results << shop
				end
			end
		elsif admin_master?
			results = @shops
		else
			@shops.each do |shop|
				if current_master.has_shop?(shop)
					results << shop
				end
			end
		end

		@shops = results
    @count = @shops.count
    if request.mobile?
      @shops = @shops.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 10
    end

    @header_shops = true;
    @shops_search = true;
    render "/shops/index"
  end

  def masters_search
    if params[:keywords] != ""
      words = params[:keywords].split(/\s+/)
      prefix, full_words = words.pop, words.join(' ')
      @masters = Sunspot.search(Master) do
        keywords(full_words, :fields => :email)
        text_fields do
          with(:email).starting_with(prefix)
        end
      end
      @masters = @masters.results
    else
      @masters = Master.all
    end

    @header_masters = true;
    @masters_search = true;
    render "/masters/index"
  end

  def customers_search
    if params[:keywords] != ""
      words = params[:keywords].split(/\s+/)
      prefix, full_words = words.pop, words.join(' ')
      @customers = Sunspot.search(Customer) do
        keywords(full_words, :fields => :email)
        text_fields do
          with(:email).starting_with(prefix)
        end
      end
      @customers = @customers.results
    else
      @customers = Customer.all
    end

    @header_customers = true;
    @customers_search = true;
    render "/customers/index"
  end

	def coupon_analysis_records_search
		@coupon = Coupon.find(params[:id])
		record_start_at = params[:record_start_at]
		record_end_at = params[:record_end_at]
		@records = CouponAnalysisRecord.where("(activated_at >= ? AND activated_at <= ?) OR (inactivated_at >= ? AND inactivated_at <= ?)", record_start_at, record_end_at, record_start_at, record_end_at)

    @title = @coupon.title
    @header_coupons = true
    @sub_header = true
    @coupon_analysis_info = true

		render '/coupon_analysis_records/index'		
	end
end


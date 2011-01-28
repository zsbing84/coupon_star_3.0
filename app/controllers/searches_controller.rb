# -*- encoding : utf-8 -*-
class SearchesController < ApplicationController

  def coupons_search
    if params[:keywords] != ""
      words = params[:keywords].split(/\s+/)
      prefix, full_words = words.pop, words.join(' ')
      @coupons = Sunspot.search(Coupon) do
        keywords(full_words, :fields => :title)
        text_fields do
          with(:title).starting_with(prefix)
        end
      end
      @coupons = @coupons.results
    else
      @coupons = Coupon.all
    end

		results = []
		if request.mobile?
			customer = Customer.find(params[:customer_id])
			@coupons.each do |coupon|
				if customer.has_coupon?(coupon)
					results << coupon
				end
			end
		elsif admin_master?
			results = @coupons
		else
			master = Master.find(params[:master_id])
			@coupons.each do |coupon|
				if master.has_coupon?(coupon)
					results << coupon
				end
			end
		end

		@coupons = results
    @header_coupons = true;
    @coupons_search = true;
    render "/coupons/index"
  end

  def shops_search
    if params[:keywords] != ""
      words = params[:keywords].split(/\s+/)
      prefix, full_words = words.pop, words.join(' ')
      @shops = Sunspot.search(Shop) do
        keywords(full_words, :fields => :name)
        text_fields do
          with(:name).starting_with(prefix)
        end
      end
      @shops = @shops.results
    else
      @shops = Shop.all
    end

		results = []
		if request.mobile?
			customer = Customer.find(params[:customer_id])
			@shops.each do |shop|
				if customer.following?(shop)
					results << shop
				end
			end
		elsif admin_master?
			results = @shops
		else
			master = Master.find(params[:master_id])
			@shops.each do |shop|
				if master.has_shop?(shop)
					results << shop
				end
			end
		end

		@shops = results
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

end


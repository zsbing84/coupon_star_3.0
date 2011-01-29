# -*- encoding : utf-8 -*-

class ShopsController < ApplicationController

	before_filter :require_no_mobile_request, :only => [:new, :create, :edit, :update, :destory, :analysis]
	before_filter :require_mobile_request, :only => [:show, :list]

	before_filter :require_master, :only => [:new, :create]
  before_filter :require_customer, :only => [:show]
	before_filter :require_master_or_customer, :only => [:index]
  before_filter :require_correct_shop_master, :only => [:edit, :update, :destory, :analysis]

	def index
		@title = "マイショップ"
    if signed_in_master? && !request.mobile?
      @shops = current_master.get_shops
    elsif signed_in_customer? && request.mobile?
      @shops = current_customer.shops
    end

    @header_shops = true
    @shops_search = false
  end

	def search
		@title = "ショップ検索"
  end

	def show
    if request.mobile?
      @shop = Shop.find(params[:id])
      @title = @shop.name
			@width = (request.mobile.display.width * 0.975).to_i
			@height = (@width * 3 / 4).to_i
			@map_img_src = "http://maps.google.com/maps/api/staticmap?center=#{@shop.address}&zoom=14&size=#{@width}x#{@height}&markers=size:mid|color:red|#{@shop.address}&sensor=true"
    end
  end

 def analysis
    if params[:commit] == "フォロワー数を表示"
      duration_id = params[:duration_id].to_i
    else
      duration_id = 1
    end

    @shop = Shop.find(params[:id])
    created_at = @shop.created_at.to_date

    young_data = @shop.get_analysis_data(duration_id, "young")
    prime_data = @shop.get_analysis_data(duration_id, "prime")
    middle_data = @shop.get_analysis_data(duration_id, "middle")
    old_data = @shop.get_analysis_data(duration_id, "old")
    male_data = @shop.get_analysis_data(duration_id, "male")
    female_data = @shop.get_analysis_data(duration_id, "female")
    all_data = @shop.get_analysis_data(duration_id, "all")
    start_at = @shop.get_analysis_start_at(duration_id)
    days_interval = @shop.get_analysis_days_interval(duration_id)

    @title = @shop.name
    @duration = ShopChartDisplayGeneral.find(duration_id)
    @sub_header = true
    @shop_analysis_info = true
    @header_shops = true
    @age_dist_chart = get_shop_age_dist_chart(
      start_at, days_interval, young_data, prime_data, middle_data, old_data, all_data)
    @gender_dist_chart = get_shop_gender_dist_chart(
      start_at, days_interval, male_data, female_data, all_data)
  end

  def edit
    @shop = Shop.find(params[:id])
		@map_img_src = "http://maps.google.com/maps/api/staticmap?center=" + @shop.address + "&zoom=14&size=400x300&markers=size:mid|color:red|" + @shop.address + "&sensor=true"

    @header_shops = true
    @sub_header = true
    @title = @shop.name
    @shop_general_info = true
  end

  def new
    @shop = Shop.new
    @title = "ショップ新規作成"
    @header_new_shop = true
  end

  def create
		if params[:commit] == "新規作成"
			@shop = Shop.new(params[:shop])
	    @shop.master_id = current_master.id
	    if @shop.save
				flash[:notice] = @shop.name + "が作成されました。"
	   		redirect_to shops_path
			else
	      @title = "ショップ新規作成"
			  @header_new_shop = true
	      render 'new'
	    end
		end
  end

  def update
    @shop = Shop.find(params[:id])
    @header_shops = true
    @sub_header = true
    @title = @shop.name
    @shop_general_info = true

    if params[:commit] == "保存"
      if @shop.update_attributes(params[:shop])
        flash[:success] = @shop.name + "が更新されました。"
        redirect_to edit_shop_path(@shop)
      else
        @address = @shop.address
        render 'edit'
      end
    end
  end

  def destroy
    shop = Shop.find(params[:id])
    shop.destroy
    flash[:success] = shop.name + "が削除されました。"
    redirect_to shops_path
  end

  def display_coupons
    @shop = Shop.find(params[:id])
    @header_coupons = true
    @shop_display_coupons = true
    @coupons = @shop.get_coupons

    render '/coupons/index'
  end

  def display_coupons
    @shop = Shop.find(params[:id])
    @header_coupons = true
    @shop_display_coupons = true
    @coupons = @shop.get_coupons

    render '/coupons/index'
  end

end


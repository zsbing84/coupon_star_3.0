# -*- encoding : utf-8 -*-
class CustomersController < ApplicationController

	trans_sid

	before_filter :require_admin, :only => [:index]
  before_filter :require_correct_customer_or_admin, :only => [:edit, :update, :destroy]

	def index
    @title = "カスタマー一覧"
		@header_customers = true
	  @customers = Customer.all
  end

  def new
    @customer = Customer.new
		@header_new_customer = true
		if request.mobile?
	    @title = "新規登録"
		else
			@title = "カスタマー作成"
		end
  end

  def create
    @customer = Customer.new(params[:customer])
		if request.mobile?
	    if @customer.save
	    	@customer.reset_perishable_token!
	    	CustomerMailer.delay.deliver_activation_instructions(@customer)
				flash[:notice] = "ご登録頂きましたメールアドレスに、「仮登録受付メール」をお送りいたしました。「仮登録受付メール」内にあるリンクをクリックし、会員登録を完了してください。"
	   		redirect_to root_path
			else
	      @title = "新規登録"
	      render 'new'
	    end
		else
	    if @customer.save
				@customer.update_attribute(:active, true)
				@header_customers = true
	   		redirect_to customers_path
			else
	      @title = "カスタマー作成"
				@header_new_customer = true
	      render 'new'
	    end
		end
  end

  def edit
	   @header_customers = true		
		if request.mobile?
			@customer = current_customer
    	@title = "マイページ"
		else
	    @customer = Customer.find(params[:id])
	    @title = "カスタマー情報"
		end
  end

  def update
		@header_customers = true		
		if request.mobile?
			@customer = Customer.find(params[:id])
	    if @customer.update_attributes(params[:customer])
	      flash[:success] = "#{@customer.email}が更新されました。"
	      render 'edit'
	    else
	    	@title = "マイページ"
	      render 'edit'
	    end
		else
			@customer = Customer.find(params[:id])
	    if @customer.update_attributes(params[:customer])
	      flash[:success] = "#{@customer.email}が更新されました。"
	      render 'edit'
	    else
	    	@title = "カスタマー情報"
	      render 'edit'
	    end		
		end

  end

  def destroy
    customer = Customer.find(params[:id])
    flash[:success] = customer.email + "が削除されました。"
    customer.destroy
    redirect_to customers_path
  end

  def display_coupons
    @customer = Customer.find(params[:id])
    @header_coupons = true
    @customer_display_coupons = true
    @coupons = @customer.get_coupons

    render '/coupons/index'
  end

  def display_shops
    @customer = Customer.find(params[:id])
    @header_shops = true
    @customer_display_shops = true
    @shops = @customer.shops

    render '/shops/index'
  end

end


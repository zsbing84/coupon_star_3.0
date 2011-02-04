# -*- encoding : utf-8 -*-
class MastersController < ApplicationController
	trans_sid
	before_filter :require_no_mobile_request, :only => [:new, :create, :edit, :update]
	before_filter :require_correct_master, :only => [:show, :edit, :update]
	before_filter :require_admin, :only => [:index, :destroy, :display_shops, :display_coupons]

	def index
    @title = "マスタ一覧"
		@header_masters = true
    @masters = Master.all
  end

  def show
  	@master = Master.find(params[:id])
    @title = @master.email
  end

  def new
    @master = Master.new
    @title = "新規登録"
		@header_new_master = true
  end

  def create
		if params[:commit] == "登録内容を送信"
			@master = Master.new(params[:master])
	    if @master.save
	    	@master.reset_perishable_token!
	    	MasterMailer.delay.deliver_activation_instructions(@master)
				flash[:notice] = "ご登録頂きましたメールアドレスに、「仮登録受付メール」をお送りいたしました。「仮登録受付メール」内にあるリンクをクリックし、会員登録を完了してください。"
	   		redirect_to master_signin_path
			else
	      @title = "新規登録"
	      render 'new'
	    end
		elsif params[:commit] == "新規作成"
			@master = Master.new(params[:master])
	    if @master.save
				@master.update_attribute(:active, true)
				flash[:notice] = @master.email + "が作成されました。"
				@header_masters = true
	   		redirect_to masters_path
			else
	      @title = "新規登録"
				@header_new_master = true
	      render 'new'
	    end
		end
  end

  def edit
    @master = Master.find(params[:id])
		if current_master?(@master)
			@title = "マイページ"
			@header_account = true
		else
			@title = "マスター情報"
			@header_masters = true
		end
  end

  def update
    @master = Master.find(params[:id])
    if @master.update_attributes(params[:master])
      flash[:success] = "#{@customer.email}が更新されました。"
      redirect_to edit_master_path(@master)
    else
    	@title = "マイページ"
      @header_account = true
      render 'edit'
    end
  end

  def destroy
		master = Master.find(params[:id])
    flash[:success] = master.email + "が削除されました。"
		master.destroy
		@header_masters = true
    redirect_to masters_path
  end

  def display_coupons
    @master = Master.find(params[:id])
    @header_coupons = true
    @master_display_coupons = true
    @coupons = @master.get_coupons

    render '/coupons/index'
  end

  def display_shops
    @master = Master.find(params[:id])
    @header_shops = true
    @master_display_shops = true
    @shops = @master.get_shops

    render '/shops/index'
  end

end


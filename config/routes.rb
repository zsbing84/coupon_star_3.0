# -*- encoding : utf-8 -*-
CouponStar::Application.routes.draw do

  resources :master_sessions, :only => [:new, :create, :destroy]
	resources :master_password_resets, :only => [:new, :create, :destroy]
	resources :customer_sessions, :only => [:new, :create, :destroy]
	resources :customer_password_resets, :only => [:new, :create, :destroy]
  resources :coupon_analysis_records, :only => [:new, :create, :destroy]

  resources :masters do
		resources :shops
    member do
      get 'display_shops'
      get 'display_coupons'
    end
  end

	resources :shops do
    resources :customers, :coupons, :masters
    member do
      get 'analysis'
      get 'display_coupons'
    end
  end

	resources :coupons do
		resources :customers, :shops
		member do
      get 'analysis'
      get 'use'
    end
  end

	resources :customers do
		resources	:shops, :coupons
    member do
      get 'display_shops'
      get 'display_coupons'
    end
  end

	resources :shop_customer_rels, :only => [:create, :destroy, :update]
	resources :coupon_customer_rels, :only => [:create, :destroy]

  match '/coupon_use', :to => 'coupons#use'
  match '/coupon_analysis', :to => 'coupons#analysis'
  match '/shop_analysis', :to => 'shops#analysis'
  match '/shops_search_form', :to => 'shops#search'
	match '/master_signup',  :to => 'masters#new'
  match '/master_signin',  :to => 'master_sessions#new'
  match '/master_signout', :to => 'master_sessions#destroy'
 	match '/master_activate/:activation_code',    :to => 'master_activations#create'
  match '/customer_signup',  :to => 'customers#new'
  match '/customer_signin',  :to => 'customer_sessions#new'
  match '/customer_signout', :to => 'customer_sessions#destroy'
	match '/customer_activate/:activation_code',    :to => 'customer_activations#create'
	match '/contact', :to => 'pages#contact'
	match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  match '/catalog',    :to => 'pages#catalog'
  match '/shops_search', :to => 'searches#shops_search'
  match '/coupons_search', :to => 'searches#coupons_search'
  match '/masters_search', :to => 'searches#masters_search'
  match '/customers_search', :to => 'searches#customers_search'
	root :to => 'pages#home'
end


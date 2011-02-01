# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

CouponStar::Application.config.session_store :active_record_store, :key => '_session_id'
CouponStar::Application.config.session_store = {:cookie_only => false}


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# CouponStar::Application.config.session_store :active_record_store


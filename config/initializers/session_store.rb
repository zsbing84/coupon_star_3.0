# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :active_record_store
Rails.application.config.session_options = {:cookie_only => false}


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# CouponStar::Application.config.session_store :active_record_store


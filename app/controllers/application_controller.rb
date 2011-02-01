# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  include CouponsHelper
  include ShopsHelper
  include MasterSessionsHelper
  include CustomerSessionsHelper

end


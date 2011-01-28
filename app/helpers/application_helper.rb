# -*- encoding : utf-8 -*-
module ApplicationHelper

	# Return a title on a per-page basis.
  def title
    base_title = "CouponStar"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def verification_code
    Time.now.to_s(:number) + @coupon.verification_code
  end

  def available_count(coupon)
		rel = current_customer.coupon_customer_rels.find_by_coupon_id(coupon.id)
		if !rel.nil?
			return rel.available_count
		else
			return 0
		end
  end

  def is_disabled?(coupon)
		if !admin_master? && coupon.active?
			return true
    else
			return false
		end
  end


	def mark_required(object, attribute)
	  "*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
	end

  def link_to_remove_fine_print_field(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
  end

  def link_to_add_fine_print_field(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("/coupons/partials/" + association.to_s.singularize + "_field", :f => builder)
    end

    link_to_function(name, "add_field(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def link_to_remove_open_hour_field(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
  end

  def link_to_add_open_hour_field(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("/shops/partials/" + association.to_s.singularize + "_field", :f => builder)
    end

    link_to_function(name, "add_field(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

end


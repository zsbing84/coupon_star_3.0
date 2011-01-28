class CouponAnalysisRecord < ActiveRecord::Base
  belongs_to :coupon

  def self.get_analysis_data(record, general_id, serie)

    array = []
    if general_id == 1
      array = get_total_views_data(record, serie)
    elsif general_id == 2
      array = get_total_clicks_data(record, serie)
    elsif general_id == 3
      array = get_total_cpv_data(record, serie)
    elsif general_id == 4
      array = get_daily_views_data(record, serie)
    elsif general_id == 5
      array = get_daily_clicks_data(record, serie)
    elsif general_id == 6
      array = get_daily_cpv_data(record, serie)
    end

		days_count = Date.today - record.activated_at.to_date + 1
		array_count = 0
    if !array.nil?
      array_count = array.count
    end

		if days_count > array_count
			update_analysis_data(record, array_count, days_count)
			if general_id == 1
	      array = get_total_views_data(record, serie)
	    elsif general_id == 2
	      array = get_total_clicks_data(record, serie)
	    elsif general_id == 3
	      array = get_total_cpv_data(record, serie)
	    elsif general_id == 4
	      array = get_daily_views_data(record, serie)
	    elsif general_id == 5
	      array = get_daily_clicks_data(record, serie)
	    elsif general_id == 6
	      array = get_daily_cpv_data(record, serie)
	    end
		end

    if record.is_current?
      results = []
      index = -1
      if record.activated_at == Date.today
        results << array[0]
        return results
      else
        (record.activated_at..Date.today).each do |date|
          index += 1
          results[index] = array[index]
        end
        return results
      end
    else
      return array
    end
  end

	def self.get_daily_views_data(record, serie)
    if serie == "young"
      array = convert_string_to_array(record.young_views)
    elsif serie == "prime"
      array = convert_string_to_array(record.prime_views)
    elsif serie == "middle"
      array = convert_string_to_array(record.middle_views)
    elsif serie == "old"
      array = convert_string_to_array(record.old_views)
    elsif serie == "male"
      array = convert_string_to_array(record.male_views)
    elsif serie == "female"
      array = convert_string_to_array(record.female_views)
    elsif serie == "all"
      array = convert_string_to_array(record.all_views)
    end
  end

	def self.get_daily_clicks_data(record, serie)
    if serie == "young"
      convert_string_to_array(record.young_clicks)
    elsif serie == "prime"
      convert_string_to_array(record.prime_clicks)
    elsif serie == "middle"
      convert_string_to_array(record.middle_clicks)
    elsif serie == "old"
      convert_string_to_array(record.old_clicks)
    elsif serie == "male"
      convert_string_to_array(record.male_clicks)
    elsif serie == "female"
      convert_string_to_array(record.female_clicks)
    elsif serie == "all"
      convert_string_to_array(record.all_clicks)
    end
  end

  def self.get_total_views_data(record, serie)
    if serie == "young"
      get_total_count_data(record.young_views)
    elsif serie == "prime"
      get_total_count_data(record.prime_views)
    elsif serie == "middle"
      get_total_count_data(record.middle_views)
    elsif serie == "old"
      get_total_count_data(record.old_views)
    elsif serie == "male"
      get_total_count_data(record.male_views)
    elsif serie == "female"
      get_total_count_data(record.female_views)
    elsif serie == "all"
      get_total_count_data(record.all_views)
    end
  end

  def self.get_total_clicks_data(record, serie)
    if serie == "young"
      get_total_count_data(record.young_clicks)
    elsif serie == "prime"
      get_total_count_data(record.prime_clicks)
    elsif serie == "middle"
      get_total_count_data(record.middle_clicks)
    elsif serie == "old"
      get_total_count_data(record.old_clicks)
    elsif serie == "male"
      get_total_count_data(record.male_clicks)
    elsif serie == "female"
      get_total_count_data(record.female_clicks)
    elsif serie == "all"
      get_total_count_data(record.all_clicks)
    end
  end

  def self.get_daily_cpv_data(record, serie)
    daily_views_data = get_daily_views_data(record, serie)
    daily_clicks_data = get_daily_clicks_data(record, serie)
    index = -1
    daily_views_data.map do |value|
			index = index + 1
			if value != 0
	      daily_clicks_data[index] * 100 / value
			else
				0
			end
    end
  end

  def self.get_total_cpv_data(record, serie)
    total_views_data = get_total_views_data(record, serie)
    total_clicks_data = get_total_clicks_data(record, serie)
    index = -1
    total_views_data.map do |value|
			index = index + 1
      if value != 0
        total_clicks_data[index] *100 / value
			else
				0
			end
    end
  end

  def self.convert_string_to_array(string)
		if string.nil?
			return nil
		else
			return string.split(',').map(&:to_i)
		end
  end

  def self.convert_array_to_string(array)
    array.join(', ')
  end

  def self.get_total_count_data(string)
    data = convert_string_to_array(string)
    sum = 0
    data.map do |value|
      sum += value
    end
  end

	def self.update_analysis_data(record, array_count, days_count)
		young_views_array = convert_string_to_array(record.young_views)
		young_clicks_array = convert_string_to_array(record.young_clicks)
		prime_views_array = convert_string_to_array(record.prime_views)
		prime_clicks_array = convert_string_to_array(record.prime_clicks)
		middle_views_array = convert_string_to_array(record.middle_views)
		middle_clicks_array = convert_string_to_array(record.middle_clicks)
		old_views_array = convert_string_to_array(record.old_views)
		old_clicks_array = convert_string_to_array(record.old_clicks)
		male_views_array = convert_string_to_array(record.male_views)
		male_clicks_array = convert_string_to_array(record.male_clicks)
		female_views_array = convert_string_to_array(record.female_views)
		female_clicks_array = convert_string_to_array(record.female_clicks)
		all_views_array = convert_string_to_array(record.all_views)
		all_clicks_array = convert_string_to_array(record.all_clicks)

		(array_count..(days_count-1)).each do |index|
      young_views_array << 0
			young_clicks_array << 0
			prime_views_array << 0
			prime_clicks_array << 0
			middle_views_array << 0
			middle_clicks_array << 0
			old_views_array << 0
			old_clicks_array << 0
			male_views_array << 0
			male_clicks_array << 0
			female_views_array << 0
			female_clicks_array << 0
			all_views_array << 0
			all_clicks_array << 0
		end

    record.update_attributes(:young_views => convert_array_to_string(young_views_array))
    record.update_attributes(:young_clicks => convert_array_to_string(young_clicks_array))
    record.update_attributes(:prime_views => convert_array_to_string(prime_views_array))
    record.update_attributes(:prime_clicks => convert_array_to_string(prime_clicks_array))
    record.update_attributes(:middle_views => convert_array_to_string(middle_views_array))
    record.update_attributes(:middle_clicks =>  convert_array_to_string(middle_clicks_array))
    record.update_attributes(:old_views => convert_array_to_string(old_views_array))
    record.update_attributes(:old_clicks => convert_array_to_string(old_clicks_array))
    record.update_attributes(:male_views => convert_array_to_string(male_views_array))
    record.update_attributes(:male_clicks => convert_array_to_string(male_clicks_array))
    record.update_attributes(:female_views => convert_array_to_string(female_views_array))
    record.update_attributes(:female_clicks => convert_array_to_string(female_clicks_array))
    record.update_attributes(:all_views => convert_array_to_string(all_views_array))
    record.update_attributes(:all_clicks => convert_array_to_string(all_clicks_array))
	end

end


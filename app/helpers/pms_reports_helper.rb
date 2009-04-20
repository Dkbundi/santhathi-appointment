module PmsReportsHelper

  def calculate_count(reports,date)
  	value = reports[date]
  	return 0 if value.nil?
 	@count += value
  	return value

  end



  def display_mode(id)
  	name = Mode.find(id).name
  	return name
  end

  def count_all(date)
  	@others = 0
    @telephonic = 0
    @walk_ins = 0

    appointments = Appointment.find(:all,:conditions =>['appointment_date = ?',date])

    unless appointments.blank?
      appointments.each do |app|
    	case app.mode_id
  		   when @mode_ids[0]
  		   	   @others += 1
  		   	   @total_others +=1
 		   when @mode_ids[1]
 		   	  @telephonic += 1
 		   	  @total_telephonic +=1
		   when @mode_ids[2]
              @walk_ins += 1
              @total_walkins +=1
   		end
   	 end
  	end
    return
  end

  def add_all
     sum = @total_others + @total_telephonic + @total_walkins
     return sum
  end

  def count_first_visit(date)
  	 count = 0
  	 count = Appointment.count(:conditions=>['appointment_date = ? and visit_type = ?',date,"yes"])
  	 @count_visit_type += count
  	 return count
  end

  def count_follow_up(date)
  	count = 0
  	count = Appointment.count(:conditions=>['appointment_date = ? and visit_type = ?',date,"no"])
  	@count_visit_type += count
  	return count
  end

end

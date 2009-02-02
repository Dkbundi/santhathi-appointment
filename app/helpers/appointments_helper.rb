module AppointmentsHelper
  def iteration_count(doctor)
    dt1 = Time.parse(doctor.working_from.to_s)
    dt2 = Time.parse(doctor.working_to.to_s)
    return ((((dt2 - dt1)/60)/60)* 12).to_i
  end

  def doctors_list(dept_id = nil)
    if dept_id.nil?
      doctors = Doctor.find(:all).collect{|x| [x.name, x.id]}
    else
      doctors = Department.find(dept_id).doctors
    end
    
    return doctors
  end
  
  def hours
     b = []
     (0..23).step(1) do |num|
      b << num
     end
    return b
  end

  def minutes
     b = []
     (0..55).step(5) do |num|
      b << num
     end
    return b
  end
end

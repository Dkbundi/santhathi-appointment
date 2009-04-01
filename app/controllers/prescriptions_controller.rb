class PrescriptionsController < ApplicationController
  layout 'cms'
  
  def index
    

  end

  def new
    @prescription = Prescription.new
    @department = Department.find(params[:department])
    @appointment = Appointment.find(params[:appointment])
    @child_list = @department.services.find_all_by_parent_id(nil)
    @prescription_list = @appointment.prescriptions
   
    respond_to do |format|
      format.html
      format.js { render :update do |page|
                    page.replace_html 'clinical-screen', :partial => 'prescriptions/new'
                  end
                }
    end 
  end


  def create
    @prescription = Prescription.new(params[:prescription])
    @department = Department.find(params[:prescription][:department_id])
    @appointment = Appointment.find(params[:prescription][:appointment_id])
    @prescription_list = @appointment.prescriptions

    respond_to do |format|
      if @prescription.save
        params[:services].map{|service| PrescribedTest.create(:prescription_id => @prescription.id, :service_id => service)}
        format.html
        format.js { render :update do |page|
                      page.replace_html 'clinical-screen', :partial => 'prescriptions/new', :object => @prescription_list
                    end
                  }
      else
        format.html { redirect_to clinical_screen_doctor_patients_url(:id => @appointment) }
      end
    end
  end
end

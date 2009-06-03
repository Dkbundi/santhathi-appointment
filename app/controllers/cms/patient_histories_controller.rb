class Cms::PatientHistoriesController < ApplicationController
  layout 'patient_history'
  before_filter :find_appointment ,:except =>[:show,:index]

  def index
  	@patient = Patient.find(65)
  	@appointment = Appointment.find(6)
  end




  def show
  	@patient = Patient.find(params[:id])
  	@appointments = @patient.appointments
  end

  def prescription
  	@prescription = @appointment.prescription
 		@prescribed_tests = @prescription.prescribed_tests
    render :update do |page|
      page.replace_html 'patient-history', :partial => 'cms/patient_histories/prescription'
    end

 	end


 	def reports
 		@laboratory_reports = LaboratoryReport.find(:all,:conditions =>["appointment_id = ?", @appointment.id])
 		render :update do |page|
                       page.replace_html 'patient-history', :partial => 'cms/patient_histories/reports'
                  end

	end

	def pharmacy_prescription
		@pharmacy_prescriptions = @appointment.pharmacy_prescriptions
		    render :update do |page|
                        page.replace_html 'patient-history', :partial => 'cms/patient_histories/pharmacy_prescription'
                      end

	end

	def transfer_history

                     render :update do |page|
                        page.replace_html 'patient-history', :partial => 'cms/patient_histories/transfer_history'
                      end

	end

	def alerts
		     render :update do |page|
                        page.replace_html 'patient-history', :partial => 'cms/patient_histories/alerts'
                      end

	end

	def discharge_summary

    @discharge_summary = @appointment.discharge_summary

                     render :update do |page|

                        page.replace_html 'patient-history', :partial => 'cms/patient_histories/discharge_summary'
                      end

	end

	def clinical_comment
		@clinical_comment = @appointment.clinical_comment
		render :update do |page|
         page.replace_html 'patient-history', :partial => 'cms/patient_histories/clinical_comment'
    end

	end

	private

	def find_appointment
		@appointment = Appointment.find(params[:appointment_id])
	end

end

class AppointmentsController < ApplicationController
layout 'admin'
require_role ["doctor", "admin", "reception"]#, :only => [:delete, :edit]
  # GET /appointments
  # GET /appointments.xml
  def index
    respond_to do |format|
      format.html { @appointments = Appointment.paginate(:all, :per_page => 10, :page => params[:page]) 
                    session[:doctor] = nil
                    session[:date] = nil
                  }
      format.js   {  
                    unless params[:doctor].blank?
                      @doctor = Doctor.find(params[:doctor])
                      session[:doctor] = @doctor
                    else
                      unless params[:date].blank?
                        @doctor = session[:doctor]
                      else
                        @doctor = nil
                      end 
                    end
                    
                    unless params[:date].blank?
                      @date = Date.parse(params[:date])
                      session[:date] = @date
                    else
                      @date = session[:date]
                    end
                     
                    render :update do |page|
                      page.replace_html 'schedule', :partial => 'appointments_detail', :locals => {:doctor => @doctor, :date =>@date}
                    end
                  }
    end
  end

  # GET /appointments/1
  # GET /appointments/1.xml
  def show
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @appointment }
      format.js { render :layout => false }
    end
  end

  # GET /appointments/new
  # GET /appointments/new.xml
  def new
    @appointment = Appointment.new
    #@patient = Patient.new(:reg_no => generate_identifier)
    session[:doctor] = nil
    session[:date] = nil
    respond_to do|format|
      format.html # new.html.erb
      format.xml  { render :xml => @appointment }
    end
  end

  # GET /appointments/1/edit
  def edit
    @appointment = Appointment.find(params[:id])
    @patient = @appointment.patient
    @hour = Time.parse(@appointment.appointment_time.to_s).strftime('%H').to_i
    @minute = Time.parse(@appointment.appointment_time.to_s).strftime('%M').to_i
  end

  # POST /appointments
  # POST /appointments.xml
 def create
    date = session[:date].blank? ? Date.today : session[:date]
    @appointment = Appointment.new(params[:appointment].merge({:appointment_date => date}))
    
    if params[:new_patient_check] == 'yes'
      @patient = Patient.new(params[:patient]) 
    else
      @patient = Patient.find(params[:patient_id])
    end

    if [@appointment.valid?, @patient.valid?].all?
      if @appointment.save && @patient.save
        @appointment.patient = @patient
        @appointment.save
        flash[:notice] = 'Appointment was successfully created.'
        redirect_to appointments_path
      else
        render :action => "new"  
      end
    else
      render :action => "new"
    end
  end

  # PUT /appointments/1
  # PUT /appointments/1.xml
  def update
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        flash[:notice] = 'Appointment was successfully updated.'
        format.html { redirect_to(appointments_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @appointment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.xml
  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to(appointments_url) }
      format.xml  { head :ok }
    end
  end

  def update_doctors
    # updates doctors list based on department selected
    department = Department.find(params[:department])
    doctors  = department.doctors

    render :update do |page|
      page.replace_html 'doctors', :partial => 'doctors_list', :object => doctors
    end
  end
  
  def patient_search
    @patients = Patient.name_filter(params[:name]) unless params[:name].blank?
    render :update do |page|
      page.replace_html 'patient_search_results', :partial => 'patient_search_results', :object => @patients
    end
  end
  
  def calendar_change

  end
  
  def confirm
    @appointment = Appointment.find(params[:id])
    if @appointment.new_app?
       @appointment.mark_visited!
       redirect_to edit_patient_url(@appointment.patient, :reg_type => params[:reg_type])    
    end
  end
  
private
 
end

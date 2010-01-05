class Admin::MessagesController < ApplicationController
  require_role :admin
  layout 'admin_single_column'

  # GET /admin_messages
  # GET /admin_messages.xml
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_messages }
    end
  end

  # GET /admin_messages/1
  # GET /admin_messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /admin_messages/new
  # GET /admin_messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /admin_messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /admin_messages
  # POST /admin_messages.xml
  def create
    @message = Message.new(params[:admin_message])
     
     if params[:contacts].blank? and params[:message][:number].blank?
      flash.now[:error] = "Please select either a number from contact groups or enter a number."
      render :action => "new"
      return nil
    end
      
    if params[:admin_message][:message_body].blank?
      flash.now[:error] = "Please enter the message content."
      render :action => "new"
      return nil
    end
    
 
    if @message.save
      begin
      if !params[:contacts].nil?
       params[:contacts].each do |c|
 
        contact = ContactList.find(c)
        sms = Admin::MessageService.create(:sms => params[:admin_message].merge!({:number => contact.number}))
        message_contact = MessageContactList.create(:message_id => @message.id, :contact_list_id => contact.id, :sms_id => sms.id)                 
        end
         
       elsif !params[:message][:number].nil?
          sms = Admin::MessageService.create(:sms => params[:admin_message].merge!({:number => params[:message][:number]}))
          @message.update_attributes({:status => "Sent", :sms_id => sms.id, :number => params[:message][:number] })
       end
        rescue
          flash.now[:error] = 'There seems to be a problem in sending message. Please try again.'  
          render :action => "new"
          return
        end
          
          flash[:notice] = 'SMS has been sent successfully.'
          redirect_to(new_admin_message_url) 
          
        else
          render :action => "new" 
          
        end

    
    
  end

  # PUT /admin_messages/1
  # PUT /admin_messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_messages/1
  # DELETE /admin_messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(admin_messages_url) }
      format.xml  { head :ok }
    end
  end

 def render_message_template
   @message = SavedMessage.find(params[:admin_message_id]).content rescue ''
   render :update do |page|
     page << "jQuery('#admin_message_message_body').val('#{@message}')"
   end
 end

 def render_contact_list
   @contact_lists = ContactList.find(:all,:conditions => {:contact_group_id => "#{params[:contact_group_contact_group]}"}) rescue ''
   
   render :update do |page|
    if !@contact_lists.blank?
     page.replace_html 'contact-number', :partial => 'contact_list'
    else
     page.replace_html 'contact-number', :partial => 'mobile_number'
    end
   end
                 
 end
end

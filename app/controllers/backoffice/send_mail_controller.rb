class Backoffice::SendMailController < BackofficeController

  def edit
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def create
    begin
      AdminMailer.send_message(current_admin, params[:"recipient-name"], params[:"subject-name"], params[:"message-text"]).deliver_now
      @notify_message = t('message.email_send_success')
      @notify_flag = "success"
    rescue
      @notify_message = t('message.email_send_error')
      @notify_flag = "error"
    end
    respond_to do |format|
      format.js
    end
  end

end

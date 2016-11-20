class NotificationContentsController < ApplicationController
  before_action :set_notification_content, only: [:show, :edit, :update, :destroy]

  # POST /notification_contents
  # POST /notification_contents.json
  def create
    @notification_content = NotificationContent.new(notification_content_params)

    respond_to do |format|
      if @notification_content.save
        format.json { render :show, status: :created, location: @notification_content }
      else
        format.json { render json: @notification_content.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def check_role_admin
      current_user.role == 'Admin' || current_user.role == 'Master'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_content_params
      params.require(:notification_content).permit(:title, :message_body, :send_to, :attachment_cache, :attachment, {attachments: []})
    end
end

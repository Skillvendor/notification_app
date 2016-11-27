class NotificationContentsController < ApplicationController

  before_action :set_notification_content, only: [:show, :edit, :update, :destroy]

  # POST /notification_contents
  # POST /notification_contents.json
  def create
    @ids = []
    if params[:notification_content] && params[:notification_content][:send_to]
      @ids = params[:notification_content][:send_to]
    else
      @users = User.all

      # if params[:serie]
      #   @user = @user.where('groups @> [{ serie: ? }]', params[:serie])
      # end

      # if params[:year]
      #   @user = @user.where('groups @> [{ year: ? }]', params[:year])
      # end

      # if params[:group_number]
      #   @user = @user.where('grops @> [{ group_number: > }]', params[:group_number])
      # end

      @ids = @users.map(&:id)
    end

    @notification_content = NotificationContent.new(notification_content_params)
    @notification_content.send_to = @ids
    if @notification_content.save!
      render :show, status: :ok 
    else
      render status: :unprocessable_entity, json: { errors: @notification_content.errors}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def check_role_admin
      current_user.role == 'Admin' || current_user.role == 'Master'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_content_params
      params.require(:notification_content).permit(:title, :message_body, send_to: [], :attachment_cache, :attachment, {attachments: []})
    end
end
class NotificationContentsController < ApplicationController
  before_action :set_notification_content, only: [:show, :edit, :update, :destroy]

  # GET /notification_contents
  # GET /notification_contents.json
  def index
    @notification_contents = NotificationContent.all
  end

  # GET /notification_contents/1
  # GET /notification_contents/1.json
  def show
  end

  # GET /notification_contents/new
  def new
    @notification_content = NotificationContent.new
  end

  # GET /notification_contents/1/edit
  def edit
  end

  # POST /notification_contents
  # POST /notification_contents.json
  def create
    @notification_content = NotificationContent.new(notification_content_params)

    respond_to do |format|
      if @notification_content.save
        format.html { redirect_to @notification_content, notice: 'Notification content was successfully created.' }
        format.json { render :show, status: :created, location: @notification_content }
      else
        format.html { render :new }
        format.json { render json: @notification_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notification_contents/1
  # DELETE /notification_contents/1.json
  def destroy
    @notification_content.destroy
    respond_to do |format|
      format.html { redirect_to notification_contents_url, notice: 'Notification content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification_content
      @notification_content = NotificationContent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_content_params
      params.require(:notification_content).permit(:title, :message_body, :send_to, :attachment_cache, :attachment, {attachments: []})
    end
end

class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.where(user_id: params[:user_id], expired: false)
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.expired = true
    @notification.save
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:title, :body, :user_id, :expired)
    end
end

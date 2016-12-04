class NotificationContentsController < ApplicationController
  before_action :check_role
  before_action :set_notification_content, only: [:show, :edit, :update, :destroy]

  def new
    @notification_content = NotificationContent.new
    @user_info = User.pluck(:groups)
    @series = []
    @years = []
    @group_numbers = []
    @user_info.each do |group_array|
      group_array.each do |user_hash|
        @series << user_hash['serie']
        @years << user_hash['year']
        @group_numbers << user_hash['group_number']
      end
    end

    @series = @series.uniq
    @years = @years.uniq
    @group_numbers = @group_numbers.uniq
  end

  def create
    @ids = []
    if params[:notification_content] && params[:notification_content][:send_to]
      @ids = params[:notification_content][:send_to]
    else
      @users = User.all

      if params[:serie] && params[:serie].present?
        @users = @users.where('groups @> ?', '[{ "serie":' + params[:serie].to_s + ' }]' )
      end

      if params[:year] && params[:year].present?
        @users = @users.where('groups @> ?', '[{ "year":' + params[:year].to_s + ' }]' )
      end

      if params[:group_number] && params[:group_number].present?
        @users = @users.where('groups @> ?', '[{ "group_number":' + params[:group_number].to_s + ' }]' )
      end

      if params[:group] && params[:group].present?
        @users = @users.joins(:memberships).where('members.group_id = ?', params[:group])
      end

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
    def check_role
      unless current_admin && (current_admin.role == 'Master' || current_admin.role == 'Admin')
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_content_params
      params.require(:notification_content).permit(:title, :message_body, :attachment_cache, :attachment, {attachments: []})
    end
end

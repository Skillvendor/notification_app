class AccessController < ApplicationController
  before_action :check_role_master
  before_action :set_updatable_user

  def update
    @user.role = 'Admin'

    respond_to do |format|
      if @user.save
        format.json { render :show, status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def check_role
      current_user.role == 'Master'
    end

    def set_updatable_user
      @user = User.find(params[:user][:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:title, :body, :user_id, :expired)
    end
end

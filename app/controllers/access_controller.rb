class AccessController < ApplicationController
  before_action :check_role_master
  before_action :set_admin, only: [:update]

  def index 
    @admins = Admin.where("role != ? ", 'Master')
  end

  def update
    @admin.role = 'Admin'

    respond_to do |format|
      if @admin.save
        format.html { redirect_to access_index_path }
      else
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to access_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def check_role_master
      unless current_admin && current_admin.role == 'Master'
        redirect_to root_path
      end
    end

    def set_admin
      @admin = Admin.find(params[:id])
    end
end

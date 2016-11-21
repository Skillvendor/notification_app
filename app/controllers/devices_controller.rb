class DevicesController < ApplicationController
  before_action :set_device, only: [:update]

  def update
    respond_to do |format|
      if @device.update_attributes(device_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_device
      @device = Device.find_by_uuid(params[:id])
    end

    def device_params
      params.require(:device).permit(:token)
    end
end
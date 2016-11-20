module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    load "#{Rails.root}/lib/auth_app.rb"
    respond_to :json

    def create
      render status: 403 if current_user.present?
      @response = JSON.parse(AuthApp.authenticate_user(params[:user][:email], params[:user][:password]))

      if @response['status'] == 'success'
        user = User.find_by_email(params[:user][:email])
        if user.present?
          @resource = user
        else
          build_resource(creation_params)
        end 
        
        add_token
        if @resource.save
          add_device_if_present
          log_in
        else
          clean_up_passwords @resource
          render status: :unprocessable_entity, json: { errors: @resource.errors}
        end
      else
        render status: :unprocessable_entity, json: {}
      end
    end

    protected

    def add_device_if_present
      if params[:device_uuid] && !@resource.devices.where(uuid: params[:device_uuid]).present?
        @resource.devices.create(uuid: params[:device_uuid])
      end
    end

    def log_in
      update_auth_header
      sign_in(:user, @resource, store: false, bypass: false)
      render_create_success
    end

    def build_resource(hash=nil)
      @resource = User.new_with_session(hash || {}, session)
      @resource.provider = "email"
    end

    def add_token
      @client_id = SecureRandom.urlsafe_base64(nil, false)
      @token     = SecureRandom.urlsafe_base64(nil, false)

      @resource.tokens[@client_id] = {
        token: BCrypt::Password.create(@token),
        expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
      }
    end

    def sign_up_params
      params.require(:user).permit(:email, :password)
    end

    def creation_params
      valid_keys_user = %w(last_name first_name email)
      valid_keys_group_data = %w(serie year specialization management_id group_number)
      @response['data']['user'].slice!(*valid_keys_user)
      if @response['data']['extra']['groups']['data']
        @response['data']['extra']['groups']['data'].each do |group_data|
          group_data.slice!(*valid_keys_group_data)
        end
      end
      
      @response['data']['user']['groups'] = {}
      @response['data']['user']['groups']['data'] = @response['data']['extra']['groups']['data']
      @response['data']['user']
    end
  end
end
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
      valid_keys = %w(last_name first_name email)
      @response['data']['user'].slice!(*valid_keys)
      @response['data']['user']
    end
  end
end
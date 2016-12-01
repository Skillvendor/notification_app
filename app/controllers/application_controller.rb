class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  def current_admin
    warden.authenticate(scope: :admin)
  end
end

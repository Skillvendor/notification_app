class AuthApp
  def self.endpoint
    'http://193.226.51.18:8888'
  end

  def self.authenticate_user(email, password)
    return_error_reponse do
      api_post("/api/V2/auth", {
        username: email,
        password: password
      })
    end
  end

  private

  def self.api_post(route, post_params, options={})
    options.merge!(:content_type => :json, :accept => :json)
    RestClient.post endpoint + route, post_params, options
  end
  
  def self.return_error_reponse
    begin
      yield if block_given?
    rescue => e
      e.response
    end
  end
end
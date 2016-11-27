class IosPushNotification

  attr_accessor :apn, :token
  def initialize()
    #@apn ||= Rails.env.production? ? Houston::Client.production : Houston::Client.development
    @apn ||= Houston::Client.development
    @apn.certificate = cert_file_devlopment
  end

  def send_alert_notification(token, message)
    notification = Houston::Notification.new(device: token)
    notification.alert = message
    @apn.push(notification)
  end

  private

    def cert_file_devlopment
      File.read(Rails.root.join('vendor', 'universityLife.pem'))
    end
end
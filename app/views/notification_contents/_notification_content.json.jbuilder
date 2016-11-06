json.extract! notification_content, :id, :title, :message_body, :send_to, :created_at, :updated_at
json.url notification_content_url(notification_content, format: :json)
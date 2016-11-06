json.extract! notification, :id, :title, :body, :user_id, :expired, :created_at, :updated_at
json.url notification_url(notification, format: :json)
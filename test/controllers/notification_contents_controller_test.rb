require 'test_helper'

class NotificationContentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification_content = notification_contents(:one)
  end

  test "should get index" do
    get notification_contents_url
    assert_response :success
  end

  test "should get new" do
    get new_notification_content_url
    assert_response :success
  end

  test "should create notification_content" do
    assert_difference('NotificationContent.count') do
      post notification_contents_url, params: { notification_content: { message_body: @notification_content.message_body, send_to: @notification_content.send_to, title: @notification_content.title } }
    end

    assert_redirected_to notification_content_url(NotificationContent.last)
  end

  test "should show notification_content" do
    get notification_content_url(@notification_content)
    assert_response :success
  end

  test "should get edit" do
    get edit_notification_content_url(@notification_content)
    assert_response :success
  end

  test "should update notification_content" do
    patch notification_content_url(@notification_content), params: { notification_content: { message_body: @notification_content.message_body, send_to: @notification_content.send_to, title: @notification_content.title } }
    assert_redirected_to notification_content_url(@notification_content)
  end

  test "should destroy notification_content" do
    assert_difference('NotificationContent.count', -1) do
      delete notification_content_url(@notification_content)
    end

    assert_redirected_to notification_contents_url
  end
end

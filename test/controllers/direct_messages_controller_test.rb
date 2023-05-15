require "test_helper"

class DirectMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get direct_messages_index_url
    assert_response :success
  end
end

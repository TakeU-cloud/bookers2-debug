require "test_helper"

class WeatherInfoControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get weather_info_show_url
    assert_response :success
  end
end

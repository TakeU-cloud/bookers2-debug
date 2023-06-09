class WeatherInfoController < ApplicationController
  require 'faraday'
  require 'json'

  def show
    city_name = params[:city_name]
    api_key = ENV["OPEN_WEATHER_API_KEY"]

    if city_name.present?
      begin
        response = Faraday.get "https://api.openweathermap.org/data/2.5/weather?q=#{city_name}&units=metric&appid=#{api_key}"
        data = JSON.parse(response.body)
        if response.status == 200
          @weather_info = {
            place: data['name'],
            temp_max: data['main']['temp_max'],
            temp_min: data['main']['temp_min'],
            humidity: data['main']['humidity'],
            speed: data['wind']['speed'],
            icon_url: "http://openweathermap.org/img/w/#{data['weather'][0]['icon']}.png"
          }
        else
          @error_message = "API Error: #{data['message']}"
        end
      rescue Faraday::ConnectionFailed => e
        @error_message = "Connection failed: #{e.message}"
      rescue JSON::ParserError => e
        @error_message = "Parsing failed: #{e.message}"
      rescue URI::InvalidURIError => e
        @error_message = "Invalid URI: #{e.message}"
      rescue Faraday::ClientError => e
        @error_message = "Client error: #{e.message}"
      end
    end
  end
end

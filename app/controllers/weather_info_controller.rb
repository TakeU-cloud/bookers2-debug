class WeatherInfoController < ApplicationController
  require 'faraday'
  require 'json'

  def show
    city_name = params[:city_name]
    api_key = ENV["OPEN_WEATHER_API_KEY"]
    api_key2 = ENV["TMDB_API_KEY"]

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
      # city_nameが入ったら、ついでにTMDBの映画のポスター画像5枚とタイトルを取得して、@moviesに格納する
      begin
        response = Faraday.get "https://api.themoviedb.org/3/movie/now_playing?api_key=#{api_key2}&language=ja&region=JP&page=1"
        data = JSON.parse(response.body)
        if response.status == 200
          @movies = []
          count = 0
          data['results'].each do |movie|
            @movies << {
              title: movie['title'],
              poster_path: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}"
            }
            count += 1
            break if count == 5
          end
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

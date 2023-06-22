class WeatherInfoController < ApplicationController
  require 'faraday'
  require 'json'

  def show
    city_name = params[:city_name]

    if city_name.present?
      @weather_info = fetch_weather_info(city_name)
      @movies = fetch_movies
    end
  end

  private

  def fetch_weather_info(city_name)
    api_key = ENV["OPEN_WEATHER_API_KEY"]
    url = "https://api.openweathermap.org/data/2.5/weather?q=#{city_name}&units=metric&appid=#{api_key}"
    response = make_request(url)

    if response[:status] == 200
      data = response[:body]
      {
        place: data['name'],
        temp_max: data['main']['temp_max'],
        temp_min: data['main']['temp_min'],
        humidity: data['main']['humidity'],
        speed: data['wind']['speed'],
        icon_url: "http://openweathermap.org/img/w/#{data['weather'][0]['icon']}.png"
      }
    else
      @error_message = "API Error: #{response[:body]['message']}"
      nil
    end
  end

  def fetch_movies
    api_key2 = ENV["TMDB_API_KEY"]
    url = "https://api.themoviedb.org/3/movie/now_playing?api_key=#{api_key2}&language=ja&region=JP&page=1"
    response = make_request(url)

    if response[:status] == 200
      data = response[:body]
      movies = []
      count = 0
      data['results'].each do |movie|
        movies << {
          title: movie['title'],
          poster_path: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}"
        }
        count += 1
        break if count == 5
      end
      movies
    else
      @error_message = "API Error: #{response[:body]['message']}"
      nil
    end
  end

  def make_request(url)
    begin
      response = Faraday.get url
      data = JSON.parse(response.body)
      { status: response.status, body: data }
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

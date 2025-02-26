require 'json'

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def fetch_cities
    begin
      places_response = Faraday.get("#{ENV["PLACES_ENDPOINT"]}?q=#{params[:city]}")
      places_response = JSON.parse(places_response.body)
      raise StandarError.new "Nothing to show for #{params[:city]}" if places_response.empty?

      # Filter out only cities from the response
      @cities_only_data = places_response.select { |city| city["result_type"] == "city" }
    rescue Faraday::ConnectionFailed => e
      render json: { error: "Could not connect to Places API", message: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: "No data found", message: e.message }, status: :unprocessable_entity
    end
  end

  def fetch_weather_data
    @weather_data = []
    begin
      @cities_only_data.each do |city|
        weather_response = JSON.parse(Faraday.get("#{ENV["WEATHER_ENDPOINT"]}?q=#{city["ascii_display"]}&units=metric&appid=#{ENV['WEATHER_API_KEY']}").body)
        @weather_data << weather_response
      end
    rescue Faraday::ConnectionFailed => e
      render json: { error: "Could not connect to Weather API", message: e.message }, status: :unprocessable_entity
    end
  end
end

class WeathersController < ApplicationController
  before_action :fetch_cities, :fetch_weather_data, only: [ :by_city ]

  def by_city
    @weather_data = filter_weather_data unless @weather_data.empty?

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { data: @weather_data }, status: :ok }
    end
  end

  private

  def filter_weather_data
    filtered_data = []

    @weather_data[0]["list"].each do |list|
      filtered_data << {
        city_name:    @weather_data[0]["city"]["name"],
        main:         list["main"],
        weather:      list["weather"],
        wind:         list["wind"]["speed"],
        dt_txt:       list["dt_txt"]
      }
    end

    filtered_data
  end
end

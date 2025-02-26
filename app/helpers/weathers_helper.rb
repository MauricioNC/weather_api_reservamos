module WeathersHelper
  def fetch_icon(icon)
    Faraday.get("#{ENV["WEATHER_ICON_ENDPOINT"]}/#{icon}")
  end
end

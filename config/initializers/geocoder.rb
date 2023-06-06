Geocoder.configure(
  lookup: :google,
  api_key: ENV['GEOCODER_API_KEY'],
  # geocoding service request timeout, in seconds (default 3):
  timeout: 5,
  # set default units to kilometers:
  units: :km,
)
include SnipeIT::API

class Location
  attr_reader :headers
  attr_reader :url

  def initialize(url, token, location_name)
    @location_name = location_name
    @location = Get.new(url, token, 'locations')
    @headers = @location.headers
    @url = @location.snipeit_url
  end

  def current_value
    @location.response['rows'].find { |location| location['name'] == @location_name }
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  end

  def exists?
    @location.response['rows'].any? { |location| location['name'] == @location_name }
  end
end

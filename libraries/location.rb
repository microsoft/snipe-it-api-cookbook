include SnipeIT::API

class Location
  attr_reader :headers
  attr_reader :url

  def initialize(endpoint, location_name)
    @location_name = location_name
    @headers = endpoint.headers
    @url = endpoint.snipeit_url('locations')
    @location = Get.new(@url, @headers)
  end

  def current_value
    @location.response['rows'].find { |location| location['name'] == @location_name }
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  rescue
    raise "Record for #{@location_name} location does not exist."
  end

  def exists?
    @location.response['rows'].any? { |location| location['name'] == @location_name }
  end
end

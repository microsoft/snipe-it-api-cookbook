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

  class DoesNotExistError < StandardError
  end

  def current_value
    @location.response['rows'].find { |location| location['name'] == @location_name }
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  rescue NoMethodError
    raise Location::DoesNotExistError, "#{@location_name} does not exist in the database!"
  end
end

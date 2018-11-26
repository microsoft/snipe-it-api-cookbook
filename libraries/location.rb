include SnipeIT::API

class Location
  attr_reader :headers
  attr_reader :endpoint_url

  def initialize(url, token, location_name)
    @location_name = location_name
    endpoint = Endpoint.new(url, token, 'locations', search: location_name)
    @location = Get.new(endpoint)
    @headers = endpoint.headers
    @endpoint_url = endpoint.join_url
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    if @location.response['rows'].empty?
      raise Location::DoesNotExistError, "#{@location_name} does not exist in the database!"
    else
      @location.response['rows'].first
    end
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  end
end

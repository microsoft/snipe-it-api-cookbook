include SnipeIT::API

class Manufacturer
  attr_reader :headers
  attr_reader :endpoint_url

  def initialize(url, token, manufacturer_name)
    @manufacturer_name = manufacturer_name
    endpoint = Endpoint.new(url, token, 'manufacturers', search: manufacturer_name)
    @manufacturer = Get.new(endpoint)
    @headers = endpoint.headers
    @endpoint_url = endpoint.snipeit_url
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    if @manufacturer.response['rows'].empty?
      raise Manufacturer::DoesNotExistError, "#{@manufacturer_name} does not exist in the database!"
    else
      @manufacturer.response['rows'].first
    end
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  end
end

include SnipeIT::API

class Manufacturer
  attr_reader :headers
  attr_reader :url

  def initialize(endpoint, manufacturer_name)
    @manufacturer_name = manufacturer_name
    @headers = endpoint.headers
    @url = endpoint.snipeit_url('manufacturers')
    @manufacturer = Get.new(@url, @headers)
  end

  def current_value
    @manufacturer.response['rows'].find do |manufacturer|
      manufacturer['name'] == @manufacturer_name
    end
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  end

  def exists?
    @manufacturer.response['rows'].any? do |manufacturer|
      manufacturer['name'] == @manufacturer_name
    end
  end
end

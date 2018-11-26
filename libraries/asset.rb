include SnipeIT::API

class Asset
  attr_reader :headers
  attr_reader :endpoint_url

  def initialize(url, token, serial_number)
    @serial_number = serial_number
    endpoint = Endpoint.new(url, token, 'hardware', serial_number)
    @asset = Get.new(endpoint)
    @headers = endpoint.headers
    @endpoint_url = endpoint.snipeit_url
  end

  def exist?
    @asset.response['rows'].any?
  end

  def deleted?
    exist? && current_value['deleted_at']
  end

  def current_value
    @asset.response['rows'].first
  end

  def asset_tag
    current_value['asset_tag']
  end

  def machine_name
    current_value['name']
  end

  def serial_number
    current_value['serial']
  end

  def id
    current_value['id']
  end
end

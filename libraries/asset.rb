include SnipeIT::API

class Asset
  attr_reader :headers
  attr_reader :url

  def initialize(endpoint, machine_name)
    @machine_name = machine_name
    @headers = endpoint.headers
    @url = endpoint.snipeit_url('hardware')
    @asset = Get.new(@url, @headers)
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    @asset.response['rows'].find do |asset|
      asset['machine_name'] == @machine_name
    end
  end

  def tag
    current_value['asset_tag']
  end

  def machine_name
    current_value['name']
  end

  def id
    current_value['id']
  rescue NoMethodError
    raise Asset::DoesNotExistError, "#{@machine_name} does not exist in the database!"
  end
end

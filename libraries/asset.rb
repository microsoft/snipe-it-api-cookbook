include SnipeIT::API

class Asset
  attr_reader :headers
  attr_reader :url

  def initialize(endpoint, asset_tag)
    @asset_tag = asset_tag
    @headers = endpoint.headers
    @url = endpoint.snipeit_url('hardware')
    @asset = Get.new(@url, @headers)
  end

  def current_value
    @asset.response['rows'].find do |asset|
      asset['asset_tag'] == @asset_tag
    end
  end

  def tag
    current_value['asset_tag']
  end
end

include SnipeIT::API

class Asset
  attr_reader :headers
  attr_reader :url

  def initialize(url, token, asset_tag)
    @asset_tag = asset_tag
    @asset = Get.new(url, token, 'hardware')
    @headers = @asset.headers
    @url = @asset.snipeit_url
  end

  def current_value
    @asset.response['rows'].find do |asset|
      asset['asset_tag'] == @asset_tag
    end
  end

  def exists?
    @asset.response['rows'].any? do |asset|
      asset['asset_tag'] == @asset_tag
    end
  end
end

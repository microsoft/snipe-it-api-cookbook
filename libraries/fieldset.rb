include SnipeIT::API

class Fieldset
  attr_reader :headers
  attr_reader :models

  def initialize(endpoint, fieldset)
    @fieldset = fieldset
    @headers = endpoint.headers
    @url = endpoint.snipeit_url('fieldsets')
    @fieldsets = Get.new(@url, @headers)
  end

  def current_value
    @fieldsets.response['rows'].find do |fieldset|
      fieldset['name'] == @fieldset
    end
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  end

  def exists?
    @fieldsets.response['rows'].any? do |fieldset|
      fieldset['name'] == @fieldset
    end
  end
end

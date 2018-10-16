include SnipeIT::API

class Fieldset
  attr_reader :headers
  attr_reader :models

  def initialize(url, token, fieldset)
    @fieldset = fieldset
    @fieldsets = Get.new(url, token, 'fieldsets')
    @headers = @fieldsets.headers
    @url = @fieldsets.snipeit_url
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

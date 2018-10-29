include SnipeIT::API

class Model
  attr_reader :headers
  attr_reader :url

  def initialize(endpoint, model_name)
    @model_name = model_name
    @headers = endpoint.headers
    @url = endpoint.snipeit_url('models')
    @model = Get.new(@url, @headers)
  end

  def current_value
    @model.response['rows'].find do |model|
      model['name'] == @model_name
    end
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  end

  def exists?
    @model.response['rows'].any? do |model|
      model['name'] == @model_name
    end
  end
end

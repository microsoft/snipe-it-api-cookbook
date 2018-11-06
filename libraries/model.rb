include SnipeIT::API

class Model
  attr_reader :headers
  attr_reader :url

  def initialize(endpoint, model_number)
    @model_number = model_number
    @headers = endpoint.headers
    @url = endpoint.snipeit_url('models')
    @model = Get.new(@url, @headers)
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    @model.response['rows'].find do |model|
      model['model_number'] == @model_number
    end
  end

  def name
    current_value['name']
  end

  def number
    current_value['model_number']
  end

  def id
    current_value['id']
  rescue NoMethodError
    raise Model::DoesNotExistError, "#{@model_number} does not exist in the database!"
  end
end

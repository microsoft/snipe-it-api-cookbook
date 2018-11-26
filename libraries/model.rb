include SnipeIT::API

class Model
  attr_reader :headers
  attr_reader :endpoint_url

  def initialize(url, token, model_number)
    @model_number = model_number
    endpoint = Endpoint.new(url, token, 'models', search: model_number)
    @headers = endpoint.headers
    @endpoint_url = endpoint.join_url
    @model = Get.new(endpoint)
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    if @model.response['rows'].empty?
      raise Model::DoesNotExistError, "#{@model_number} does not exist in the database!"
    else
      @model.response['rows'].first
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
  end
end

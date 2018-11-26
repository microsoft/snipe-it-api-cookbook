include SnipeIT::API

class Category
  attr_reader :headers
  attr_reader :endpoint_url

  def initialize(url, token, category_name)
    @category_name = category_name
    endpoint = Endpoint.new(url, token, 'categories', search: category_name)
    @category = Get.new(endpoint)
    @headers = endpoint.headers
    @endpoint_url = endpoint.join_url
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    if @category.response['rows'].empty?
      raise Category::DoesNotExistError, "#{@category_name} does not exist in the database!"
    else
      @category.response['rows'].first
    end
  end

  def id
    current_value['id']
  end

  def name
    current_value['name']
  end
end

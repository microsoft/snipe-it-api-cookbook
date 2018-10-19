include SnipeIT::API

class Category
  attr_reader :headers
  attr_reader :url

  def initialize(endpoint, category_name)
    @category_name = category_name
    @url = endpoint.snipeit_url('categories')
    @headers = endpoint.headers
    @category = Get.new(@url, @headers)
  end

  def current_value
    @category.response['rows'].find do |category|
      category['name'] == @category_name
    end
  end

  def id
    current_value['id']
  end

  def name
    current_value['name']
  end

  def exists?
    @category.response['rows'].any? do |category|
      category['name'] == @category_name
    end
  end
end

include SnipeIT::API

resource_name :category

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :category, String, name_property: true
property :category_type, String, required: true

default_action :create

load_current_value do |new_resource|
  categories = Get.new(new_resource.url, new_resource.token, 'categories', new_resource.category)
  begin
    category = categories.current_record if categories.name_exists?
    category category['name']
    category_type category['category_type']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :category do
    message = {}
    message[:name] = new_resource.category
    message[:category_type] = new_resource.category_type
    categories = Get.new(new_resource.url, new_resource.token, 'categories', new_resource.category)
    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers categories.endpoint.headers
        message(message.to_json)
        url categories.endpoint.uri
        action :post
      end
    end
  end
end

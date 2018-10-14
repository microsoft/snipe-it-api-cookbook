include SnipeIT::API

resource_name :category

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :category, String, name_property: true
property :category_type, String, required: true

default_action :create

load_current_value do |new_resource|
  endpoint = Endpoint.new(new_resource.url, new_resource.token)
  response = Get.new(endpoint.categories, new_resource.token, new_resource.category)

  begin
    category = response.current_record if response.record_exists?
    category category['name']
    category_type category['category_type']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :category do
    endpoint = Endpoint.new(new_resource.url, new_resource.token)
    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers endpoint.headers
        message({
          name: new_resource.category,
          category_type: new_resource.category_type,
        }.to_json)
        url endpoint.categories
        action :post
      end
    end
  end
end

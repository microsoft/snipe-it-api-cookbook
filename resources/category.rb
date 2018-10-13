include SnipeIT::API

resource_name :category

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :category, String, name_property: true
property :category_type, String, required: true

default_action :create

load_current_value do |new_resource|
  url = Endpoint.new(new_resource.url)
  response = Get.new(url.categories_endpoint, new_resource.token).response

  if record_exists?(response, new_resource.category)
    category = current_record(response, new_resource.category)
    category category['name']
    category_type category['category_type']
  else
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :category do
    url = Endpoint.new(new_resource.url)

    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers authorization_headers(new_resource.token)
        message({
          name: new_resource.category,
          category_type: new_resource.category_type,
        }.to_json)
        url url.categories_endpoint
        action :post
      end
    end
  end
end

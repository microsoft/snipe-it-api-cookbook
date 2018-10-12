include SnipeIT::API

resource_name :category

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :category, String, name_property: true
property :category_type, String, required: true

default_action :create

load_current_value do |new_resource|
  categories = snipeit_endpoint(new_resource.url, 'categories')
  response = http_get(categories, new_resource.token)

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
    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers authorization_headers(new_resource.token)
        message({
          name: new_resource.category,
          category_type: new_resource.category_type,
        }.to_json)
        url snipeit_endpoint(new_resource.url, 'categories')
        action :post
      end
    end
  end
end

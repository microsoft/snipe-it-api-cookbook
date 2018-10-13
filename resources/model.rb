include SnipeIT::API

resource_name :model

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :model, String, name_property: true
property :model_number, String
property :manufacturer, String
property :category, String
property :eol, Integer
property :fieldset, String

default_action :create

load_current_value do |new_resource|
  url = Endpoint.new(new_resource.url)
  response = Get.new(url.models_endpoint, new_resource.token).response

  begin
    model = current_record(response, new_resource.model)
    model model['name']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :model do
    url = Endpoint.new(new_resource.url)
    token = new_resource.token
    categories_response = Get.new(url.categories_endpoint, token).response
    manufacturers_response = Get.new(url.manufacturers_endpoint, token).response
    fieldsets_response = Get.new(url.fieldsets_endpoint, token).response
    category = current_record(categories_response, new_resource.category)
    manufacturer = current_record(manufacturers_response, new_resource.manufacturer)
    fieldset = current_record(fieldsets_response, new_resource.fieldset)['id'] if property_is_set?(:fieldset)

    message = {}
    message[:name] = new_resource.model
    message[:model_number] = new_resource.model_number if property_is_set?(:model_number)
    message[:category_id] = category['id']
    message[:manufacturer_id] = manufacturer['id']
    message[:eol] = new_resource.eol if property_is_set?(:eol)
    message[:fieldset_id] = fieldset['id'] unless fieldset.nil?

    converge_by("creating #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers authorization_headers(new_resource.token)
        message message.to_json
        url url.models_endpoint
        action :post
      end
    end
  end
end

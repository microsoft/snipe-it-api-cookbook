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
  endpoint = Endpoint.new(new_resource.url, new_resource.token)
  response = Get.new(endpoint.models, new_resource.token, new_resource.model)

  begin
    model = response.current_record if response.name_exists?
    model model['name']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :model do
    endpoint = Endpoint.new(new_resource.url, new_resource.token)
    category_response = Get.new(endpoint.categories, new_resource.token, new_resource.category)
    manufacturer_response = Get.new(endpoint.manufacturers, new_resource.token, new_resource.manufacturer)
    fieldset_response = Get.new(endpoint.fieldsets, new_resource.token, new_resource.fieldset)
    category = category_response.current_record['id'] if category_response.name_exists?
    manufacturer = manufacturer_response.current_record['id'] if manufacturer_response.name_exists?

    if property_is_set?(:fieldset)
      if fieldset_response.name_exists?
        fieldset = fieldset_response.current_record['id']
      end
    end

    message = {}
    message[:name] = new_resource.model
    message[:model_number] = new_resource.model_number if property_is_set?(:model_number)
    message[:category_id] = category
    message[:manufacturer_id] = manufacturer
    message[:eol] = new_resource.eol if property_is_set?(:eol)
    message[:fieldset_id] = fieldset if property_is_set?(:fieldset)

    converge_by("creating #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers endpoint.headers
        message message.to_json
        url endpoint.models
        action :post
      end
    end
  end
end

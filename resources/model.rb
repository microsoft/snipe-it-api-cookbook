include SnipeIT::API

resource_name :model

property :url, String, required: true
property :token, String, required: true
property :model, String, name_property: true
property :model_number, String, required: true
property :manufacturer, String
property :category, String
property :eol, Integer
property :fieldset, String

default_action :create

load_current_value do |new_resource|
  endpoint = Endpoint.new(new_resource.url, new_resource.token)
  model = Model.new(endpoint, new_resource.model_number)

  begin
    model_number model.number
  rescue StandardError
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :model_number do
    endpoint = Endpoint.new(new_resource.url, new_resource.token)
    category = Category.new(endpoint, new_resource.category)
    manufacturer = Manufacturer.new(endpoint, new_resource.manufacturer)
    fieldset = Fieldset.new(endpoint, new_resource.fieldset)
    model = Model.new(endpoint, new_resource.model)

    message = {}
    message[:name] = new_resource.model
    message[:model_number] = new_resource.model_number
    message[:category_id] = category.id
    message[:manufacturer_id] = manufacturer.id
    message[:eol] = new_resource.eol if property_is_set?(:eol)
    message[:fieldset_id] = fieldset.id if property_is_set?(:fieldset)

    converge_by("creating #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers model.headers
        message message.to_json
        url model.url
        action :post
      end
    end
  end
end

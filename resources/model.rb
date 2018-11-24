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
  model = Model.new(
    new_resource.url,
    new_resource.token,
    new_resource.model_number
  )

  begin
    model_number model.number
  rescue StandardError
    current_value_does_not_exist!
  end
end

action_class do
  def category
    Category.new(
      new_resource.url,
      new_resource.token,
      new_resource.category
    )
  end

  def manufacturer
    Manufacturer.new(
      new_resource.url,
      new_resource.token,
      new_resource.manufacturer
    )
  end

  def fieldset
    Fieldset.new(
      new_resource.url,
      new_resource.token,
      new_resource.fieldset
    )
  end

  def model
    Model.new(
      new_resource.url,
      new_resource.token,
      new_resource.model
    )
  end
end

action :create do
  converge_if_changed :model_number do
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
        url model.endpoint_url
        action :post
      end
    end
  end
end

action :delete do
  converge_by("delete #{new_resource.model} from Snipe-IT") do
    http_request "delete #{new_resource.model}" do
      headers model.headers
      url ::File.join(model.endpoint_url, model.id.to_s)
      action :delete
    end
  end
end

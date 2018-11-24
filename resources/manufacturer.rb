include SnipeIT::API

resource_name :manufacturer

property :url, String, required: true
property :token, String, required: true
property :manufacturer, String, name_property: true
property :website, String

default_action :create

load_current_value do |new_resource|
  manufacturer = Manufacturer.new(
    new_resource.url,
    new_resource.token,
    new_resource.manufacturer
  )

  begin
    manufacturer manufacturer.name
  rescue StandardError
    current_value_does_not_exist!
  end
end

action_class do
  def manufacturer
    Manufacturer.new(
      new_resource.url,
      new_resource.token,
      new_resource.manufacturer
    )
  end
end

action :create do
  converge_if_changed :manufacturer do
    message = {}
    message[:name] = new_resource.manufacturer
    message[:url] = new_resource.website if property_is_set?(:website)

    converge_by("creating #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers manufacturer.headers
        message(message.to_json)
        url manufacturer.endpoint_url
        action :post
      end
    end
  end
end

action :delete do
  converge_by("delete #{new_resource.manufacturer} from Snipe-IT") do
    http_request "delete #{new_resource.manufacturer}" do
      headers manufacturer.headers
      url ::File.join(manufacturer.endpoint_url, manufacturer.id.to_s)
      action :delete
    end
  end
end

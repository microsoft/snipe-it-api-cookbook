include SnipeIT::API

resource_name :manufacturer

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :manufacturer, String, name_property: true
property :website, String

default_action :create

load_current_value do |new_resource|
  manufacturer = Manufacturer.new(new_resource.url, new_resource.token, new_resource.manufacturer)
  begin
    manufacturer = manufacturer.name if manufacturer.exists?
    manufacturer manufacturer
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :manufacturer do
    message = {}
    message[:name] = new_resource.manufacturer
    message[:url] = new_resource.website if property_is_set?(:website)
    manufacturer = Manufacturer.new(new_resource.url, new_resource.token, new_resource.manufacturer)
    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers manufacturer.headers
        message message.to_json
        url manufacturer.url
        action :post
      end
    end
  end
end

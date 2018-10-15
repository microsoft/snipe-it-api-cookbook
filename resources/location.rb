include SnipeIT::API

resource_name :location

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :location, String, name_property: true
property :address, String
property :city, String
property :state, String
property :zip, String
property :country, String, default: 'US'
property :currency, String, default: 'USD'

default_action :create

load_current_value do |new_resource|
  locations = Get.new(new_resource.url, new_resource.token, 'locations', new_resource.location)
  begin
    location = locations.current_record if locations.name_exists?
    location location['name']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :location do
    message = {}
    message[:name] = new_resource.location
    message[:address] = new_resource.address if property_is_set?(:address)
    message[:state] = new_resource.state if property_is_set?(:state)
    message[:country] = new_resource.country
    message[:zip] = new_resource.zip if property_is_set?(:state)
    message[:currency] = new_resource.currency
    locations = Get.new(new_resource.url, new_resource.token, 'locations', new_resource.location)
    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers locations.endpoint.headers
        message(message.to_json)
        url locations.endpoint.uri
        action :post
      end
    end
  end
end

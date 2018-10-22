include SnipeIT::API

resource_name :manufacturer

property :url, String, default: node['snipeit']['api']['instance']
property :token, String
property :manufacturer, String, name_property: true
property :website, String

default_action :create

def api_token
  proc { property_is_set?(:token) ? token : chef_vault_item('snipe-it', 'api')['key'] }
end

load_current_value do |new_resource|
  endpoint = Endpoint.new(new_resource.url, api_token.call)
  manufacturer = Manufacturer.new(endpoint, new_resource.manufacturer)

  begin
    manufacturer = manufacturer.name if manufacturer.exists?
    manufacturer manufacturer
  rescue StandardError
    current_value_does_not_exist!
  end
end

action_class do
  def endpoint
    Endpoint.new(new_resource.url, api_token.call)
  end
end

action :create do
  converge_if_changed :manufacturer do
    manufacturer = Manufacturer.new(endpoint, new_resource.manufacturer)

    message = {}
    message[:name] = new_resource.manufacturer
    message[:url] = new_resource.website if property_is_set?(:website)

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

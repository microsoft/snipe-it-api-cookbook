include SnipeIT::API

resource_name :manufacturer

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :manufacturer, String, name_property: true
property :website, String

default_action :create

load_current_value do |new_resource|
  endpoint = Endpoint.new(new_resource.url, new_resource.token)
  response = Get.new(endpoint.manufacturers, new_resource.token, new_resource.manufacturer)

  begin
    manufacturer = response.current_record if response.record_exists?
    manufacturer manufacturer['name']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :manufacturer do
    endpoint = Endpoint.new(new_resource.url, new_resource.token)

    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers endpoint.headers
        message({
          name: new_resource.manufacturer,
          url: new_resource.website,
        }.to_json)
        url endpoint.manufacturers
        action :post
      end
    end
  end
end

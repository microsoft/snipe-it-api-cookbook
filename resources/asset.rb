include SnipeIT::API

resource_name :asset

property :url, String, default: node['snipeit']['api']['instance']
property :token, String, required: true
property :asset_tag, String, name_property: true
property :status, String, required: true
property :model, String, required: true

default_action :create

load_current_value do |new_resource|
  endpoint = Endpoint.new(new_resource.url, new_resource.token)
  assets = Get.new(endpoint.assets, new_resource.token, new_resource.asset_tag)

  begin
    asset = assets.current_asset if assets.asset_tag_exists?
    asset_tag asset['asset_tag']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :asset_tag do
    endpoint = Endpoint.new(new_resource.url, new_resource.token)
    status_response = Get.new(endpoint.status, new_resource.token, new_resource.status)
    model_response = Get.new(endpoint.models, new_resource.token, new_resource.model)
    status_id = status_response.current_record['id'] if status_response.name_exists?
    model_id = model_response.current_record['id'] if model_response.name_exists?

    message = {}
    message[:asset_tag] = new_resource.asset_tag
    message[:status_id] = status_id
    message[:model_id] = model_id

    converge_by("creating #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers endpoint.headers
        message message.to_json
        url endpoint.assets
        action :post
      end
    end
  end
end

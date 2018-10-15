include SnipeIT::API

resource_name :asset

property :asset_tag, String, name_property: true
property :model, String, required: true
property :purchase_date, String
property :serial_number, String, required: true
property :status, String, required: true
property :supplier, String
property :token, String, required: true
property :url, String, default: node['snipeit']['api']['instance']

default_action :create

load_current_value do |new_resource|
  assets = Get.new(new_resource.url, new_resource.token, 'hardware', new_resource.asset_tag)
  begin
    asset = assets.current_asset if assets.asset_tag_exists?
    asset_tag asset['asset_tag']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :asset_tag do
    assets = Get.new(new_resource.url, new_resource.token, 'hardware', new_resource.asset_tag)
    status = Get.new(new_resource.url, new_resource.token, 'statuslabels', new_resource.status)
    model = Get.new(new_resource.url, new_resource.token, 'models', new_resource.model)
    status_id = status.current_record['id'] if status.name_exists?
    model_id = model.current_record['id'] if model.name_exists?

    message = {}
    message[:asset_tag] = new_resource.asset_tag
    message[:serial] = new_resource.serial_number
    message[:status_id] = status_id
    message[:model_id] = model_id
    message[:purchase_date] = new_resource.purchase_date if property_is_set?(:purchase_date)
    message[:supplier] = new_resource.supplier if property_is_set?(:supplier)

    converge_by("creating #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers assets.endpoint.headers
        message message.to_json
        url assets.endpoint.uri
        action :post
      end
    end
  end
end

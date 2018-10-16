include SnipeIT::API

resource_name :asset

property :asset_tag, String, name_property: true
property :location, String
property :model, String, required: true
property :purchase_date, String
property :serial_number, String, required: true
property :status, String, required: true
property :supplier, String
property :token, String, required: true
property :url, String, default: node['snipeit']['api']['instance']

default_action :create

load_current_value do |new_resource|
  asset = Asset.new(new_resource.url, new_resource.token, new_resource.asset_tag)
  begin
    asset = asset.current_value if asset.exists?
    asset_tag asset['asset_tag']
  rescue
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :asset_tag do
    asset = Asset.new(new_resource.url, new_resource.token, new_resource.asset_tag)
    status = Status.new(new_resource.url, new_resource.token, new_resource.status)
    model = Model.new(new_resource.url, new_resource.token, new_resource.model)
    location = Location.new(new_resource.url, new_resource.token, new_resource.location)
    status_id = status.id if status.exists?
    model_id = model.id if model.exists?

    message = {}
    message[:asset_tag] = new_resource.asset_tag
    message[:serial] = new_resource.serial_number
    message[:status_id] = status_id
    message[:model_id] = model_id
    message[:location_id] = location.id if property_is_set?(:location)
    message[:purchase_date] = new_resource.purchase_date if property_is_set?(:purchase_date)
    message[:supplier] = new_resource.supplier if property_is_set?(:supplier)

    converge_by("creating #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers asset.headers
        message message.to_json
        url asset.url
        action :post
      end
    end
  end
end

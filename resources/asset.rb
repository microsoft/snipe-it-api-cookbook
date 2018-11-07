include SnipeIT::API

resource_name :asset

property :asset_tag, String
property :location, String
property :model, String, required: true
property :purchase_date, String
property :serial_number, String, required: true
property :status, String, required: true, default: 'Pending'
property :supplier, String
property :machine_name, String
property :token, String, required: true
property :url, String, required: true

default_action :create

load_current_value do |new_resource|
  endpoint = Endpoint.new(new_resource.url, new_resource.token)
  asset = Asset.new(endpoint, new_resource.asset_tag)
  begin
    machine_name asset.machine_name
  rescue StandardError
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed :machine_name do
    endpoint = Endpoint.new(new_resource.url, new_resource.token)
    asset = Asset.new(endpoint, new_resource.asset_tag)
    status = Status.new(endpoint, new_resource.status)
    model = Model.new(endpoint, new_resource.model)
    location = Location.new(endpoint, new_resource.location)

    message = {}
    message[:name] = new_resource.machine_name
    message[:asset_tag] = new_resource.asset_tag if property_is_set?(:asset_tag)
    message[:serial] = new_resource.serial_number
    message[:status_id] = status.id
    message[:model_id] = model.id
    message[:rtd_location_id] = location.id if property_is_set?(:machine_name)
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

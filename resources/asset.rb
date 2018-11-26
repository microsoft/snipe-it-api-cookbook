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
  asset = Asset.new(
    new_resource.url,
    new_resource.token,
    new_resource.serial_number
  )

  begin
    serial_number asset.serial_number
  rescue StandardError
    current_value_does_not_exist!
  end
end

action_class do
  def asset
    Asset.new(
      new_resource.url,
      new_resource.token,
      new_resource.serial_number
    )
  end

  def status
    Status.new(
      new_resource.url,
      new_resource.token,
      new_resource.status
    )
  end

  def model
    Model.new(
      new_resource.url,
      new_resource.token,
      new_resource.model
    )
  end

  def location
    Location.new(
      new_resource.url,
      new_resource.token,
      new_resource.location
    )
  end
end

action :create do
  converge_if_changed :serial_number do
    message = {}

    message[:rtd_location_id] = location.id if property_is_set?(:location)
    message[:name] = new_resource.machine_name if property_is_set?(:machine_name)
    message[:asset_tag] = new_resource.asset_tag if property_is_set?(:asset_tag)
    message[:serial] = new_resource.serial_number
    message[:status_id] = status.id
    message[:model_id] = model.id
    message[:purchase_date] = new_resource.purchase_date if property_is_set?(:purchase_date)
    message[:supplier] = new_resource.supplier if property_is_set?(:supplier)

    http_request "create #{new_resource.machine_name || new_resource.serial_number}" do
      headers asset.headers
      message message.to_json
      url asset.endpoint_url
      not_if { asset.deleted? }
      action :post
    end
  end
end

action :delete do
  http_request "delete #{new_resource.machine_name || new_resource.serial_number}" do
    headers asset.headers
    url ::File.join(asset.endpoint_url, asset.id.to_s)
    not_if { asset.deleted? }
    action :delete
  end
end

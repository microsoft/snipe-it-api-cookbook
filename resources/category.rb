include SnipeIT::API

resource_name :category

property :url, String, default: node['snipeit']['api']['instance']
property :token, String
property :category, String, name_property: true
property :category_type, String, required: true

default_action :create

def api_token
  proc { property_is_set?(:token) ? token : chef_vault_item('snipe-it', 'api')['key'] }
end

load_current_value do |new_resource|
  endpoint = Endpoint.new(new_resource.url, api_token.call)
  category = Category.new(endpoint, new_resource.category)

  begin
    category = category.name if category.exists?
    category category
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
  converge_if_changed :category do
    category = Category.new(endpoint, new_resource.category)

    message = {}
    message[:name] = new_resource.category
    message[:category_type] = new_resource.category_type

    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers category.headers
        message(message.to_json)
        url category.url
        action :post
      end
    end
  end
end

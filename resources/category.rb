include SnipeIT::API

resource_name :category

property :url, String, required: true
property :token, String, required: true
property :category, String, name_property: true
property :category_type, String, required: true

default_action :create

load_current_value do |new_resource|
  category = Category.new(
    new_resource.url,
    new_resource.token,
    new_resource.category
  )

  begin
    category category.name
  rescue StandardError
    current_value_does_not_exist!
  end
end

action_class do
  def category
    Category.new(
      new_resource.url,
      new_resource.token,
      new_resource.category
    )
  end
end

action :create do
  converge_if_changed :category do
    message = {}
    message[:name] = new_resource.category
    message[:category_type] = new_resource.category_type

    converge_by("created #{new_resource} in Snipe-IT") do
      http_request "create #{new_resource}" do
        headers category.headers
        message(message.to_json)
        url category.endpoint_url
        action :post
      end
    end
  end
end

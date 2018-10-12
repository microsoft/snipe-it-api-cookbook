api_token = chef_vault_item('snipeit', 'api')['key']
categories = {
  'macOS - Desktop' => 'asset',
  'macOS - Portable' => 'asset',
}

manufacturer 'Apple' do
  website 'https://www.apple.com'
  token api_token
  only_if { mac_os_x? }
  action :create
end

categories.each do |name, type|
  category name do
    token api_token
    category_type type
  end
end

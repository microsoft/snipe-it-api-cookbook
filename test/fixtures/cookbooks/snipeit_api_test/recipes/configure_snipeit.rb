api_token = chef_vault_item('snipeit', 'api')['key']

categories = {
  'macOS - Desktop' => 'asset',
  'macOS - Portable' => 'asset',
}

manufacturer 'Apple' do
  website 'https://www.apple.com'
  token api_token
  action :create
end

categories.each do |name, type|
  category name do
    token api_token
    category_type type
  end
end

model 'Mac Pro (Early 2009)' do
  manufacturer 'Apple'
  category 'macOS - Desktop'
  model_number 'MacPro4,1'
  token api_token
end

asset '1234567' do
  status 'Pending'
  model 'Mac Pro (Early 2009)'
  token api_token
end

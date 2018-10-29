categories = {
  'macOS - Desktop' => 'asset',
  'macOS - Portable' => 'asset',
}

api_token = node['snipeit']['api']['token']

manufacturer 'Apple' do
  website 'https://www.apple.com'
  token api_token
end

categories.each do |name, type|
  category name do
    category_type type
    token api_token
  end
end

model 'Mac Pro (Early 2009)' do
  manufacturer 'Apple'
  category 'macOS - Desktop'
  model_number 'MacPro4,1'
  token api_token
end

asset '1234567' do
  serial_number 'HALAEK123123'
  status 'Pending'
  model 'Mac Pro (Early 2009)'
  token api_token
end

location 'Building 1' do
  address '1 Company Lane'
  city 'San Francisco'
  state 'CA'
  zip '94130'
  token api_token
end

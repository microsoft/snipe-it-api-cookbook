api_token = node['snipeit']['api']['token']
url = node['snipeit']['api']['instance']

asset 'delete asset' do
  serial_number 'HALAEK123123'
  token api_token
  url url
  action :delete
end

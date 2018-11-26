url = attribute('url', decription: 'The Snipe-IT URL')
token = attribute('api_token', description: 'The API token for Snipe-IT')
snipeit = snipeit_api(url, token)

control 'delete-assets' do
  impact 0.7
  title 'Delete assets'
  describe json(content: snipeit.response('hardware', 'HALAEK123123').body) do
    its('total') { should cmp 0 }
    its('rows.first') { should cmp nil }
  end
end

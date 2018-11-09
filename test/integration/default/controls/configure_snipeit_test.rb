snipeit_url = attribute('url', decription: 'The Snipe-IT URL')
token = attribute('api_token', description: 'The API token for Snipe-IT')
headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" }
manufacturers = http("#{snipeit_url}/api/v1/manufacturers", headers: headers)
categories = http("#{snipeit_url}/api/v1/categories", headers: headers)
models = http("#{snipeit_url}/api/v1/models", headers: headers)
locations = http("#{snipeit_url}/api/v1/locations", headers: headers)
assets = http("#{snipeit_url}/api/v1/hardware", headers: headers)

control 'manufacturers' do
  impact 0.7
  title 'Create manufacturers'
  describe json(content: manufacturers.body) do
    its('rows.last') { should include 'name' => 'Apple' }
    its('rows.last') { should include 'url' => 'https://www.apple.com' }
  end
end

control 'categories' do
  impact 0.7
  title 'Create categories'
  describe json(content: categories.body) do
    its('rows.first') { should include 'name' => 'macOS - Desktop' }
    its('rows.last') { should include 'name' => 'macOS - Portable' }
  end
end

control 'models' do
  impact 0.7
  title 'Create models'
  describe json(content: models.body) do
    its('rows.last') { should include 'name' => 'Mac Pro (Early 2009)' }
    its('rows.last') { should include 'model_number' => 'MacPro4,1' }
  end
end

control 'locations' do
  impact 0.7
  title 'Create locations'
  describe json(content: locations.body) do
    its('rows.last') { should include 'name' => 'Building 1' }
    its('rows.last') { should include 'address' => '1 Company Lane' }
    its('rows.last') { should include 'city' => 'San Francisco' }
    its('rows.last') { should include 'state' => 'CA' }
    its('rows.last') { should include 'country' => 'US' }
    its('rows.last') { should include 'zip' => '94130' }
  end
end

control 'assets' do
  impact 0.7
  title 'Create assets'
  describe json(content: assets.body) do
    its('rows.last') { should include 'asset_tag' => '1234567' }
    its('rows.last') { should include 'serial' => 'HALAEK123123' }
    its('rows.last', 'status_label') { should include 'id' => 1 }
    its('rows.last') { should include 'model_number' => 'MacPro4,1' }
  end
end

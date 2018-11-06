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
    its(['rows', 0, 'name']) { should eq 'Apple' }
    its(['rows', 0, 'url']) { should eq 'https://www.apple.com' }
  end
end

control 'categories' do
  impact 0.7
  title 'Create categories'
  describe json(content: categories.body) do
    its(['rows', 0, 'name']) { should eq 'macOS - Desktop' }
    its(['rows', 0, 'category_type']) { should eq 'asset' }
    its(['rows', 2, 'name']) { should eq 'macOS - Portable' }
    its(['rows', 2, 'category_type']) { should eq 'asset' }
  end
end

control 'models' do
  impact 0.7
  title 'Create models'
  describe json(content: models.body) do
    its(['rows', 0, 'name']) { should eq 'Mac Pro (Early 2009)' }
    its(['rows', 0, 'manufacturer', 'name']) { should eq 'Apple' }
    its(['rows', 0, 'category', 'name']) { should eq 'macOS - Desktop' }
    its(['rows', 0, 'model_number']) { should eq 'MacPro4,1' }
  end
end

control 'locations' do
  impact 0.7
  title 'Create locations'
  describe json(content: locations.body) do
    its(['rows', 1, 'name']) { should eq 'Building 1' }
    its(['rows', 1, 'address']) { should eq '1 Company Lane' }
    its(['rows', 1, 'city']) { should eq 'San Francisco' }
    its(['rows', 1, 'state']) { should eq 'CA' }
    its(['rows', 1, 'country']) { should eq 'US' }
    its(['rows', 1, 'zip']) { should eq '94130' }
  end
end

control 'assets' do
  impact 0.7
  title 'Create assets'
  describe json(content: assets.body) do
    its(['rows', 0, 'asset_tag']) { should eq '1234567' }
    its(['rows', 0, 'serial']) { should eq 'HALAEK123123' }
    its(['rows', 0, 'status_label', 'name']) { should eq 'Pending' }
    its(['rows', 0, 'model', 'name']) { should eq 'Mac Pro (Early 2009)' }
  end
end

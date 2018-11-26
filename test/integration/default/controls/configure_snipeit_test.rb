url = attribute('url', decription: 'The Snipe-IT URL')
token = attribute('api_token', description: 'The API token for Snipe-IT')
snipeit = snipeit_api(url, token)

control 'create-manufacturers' do
  impact 0.7
  title 'Create manufacturers'
  describe json(content: snipeit.response('manufacturers', 'Apple').body) do
    its('total') { should cmp 1 }
    its('rows.first') { should include 'name' => 'Apple' }
    its('rows.first') { should include 'url' => 'https://www.apple.com' }
  end
end

control 'create-categories' do
  impact 0.7
  title 'Create categories'
  categories = ['macOS - Desktop', 'macOS - Portable']

  categories.each do |category|
    describe json(content: snipeit.response('categories', category).body) do
      its('total') { should cmp 1 }
      its('rows.first') { should include 'name' => category }
    end
  end
end

control 'create-models' do
  impact 0.7
  title 'Create models'
  describe json(content: snipeit.response('models', 'Mac Pro (Early 2009)').body) do
    its('total') { should cmp 1 }
    its('rows.first') { should include 'name' => 'Mac Pro (Early 2009)' }
    its('rows.first') { should include 'model_number' => 'MacPro4,1' }
  end
end

control 'create-locations' do
  impact 0.7
  title 'Create locations'
  describe json(content: snipeit.response('locations', 'Building 1').body) do
    its('total') { should cmp 1 }
    its('rows.first') { should include 'name' => 'Building 1' }
    its('rows.first') { should include 'address' => '1 Company Lane' }
    its('rows.first') { should include 'city' => 'San Francisco' }
    its('rows.first') { should include 'state' => 'CA' }
    its('rows.first') { should include 'country' => 'US' }
    its('rows.first') { should include 'zip' => '94130' }
  end
end

control 'create-assets' do
  impact 0.7
  title 'Create assets'
  describe json(content: snipeit.response('hardware', 'HALAEK123123').body) do
    its('total') { should cmp 1 }
    its('rows.first') { should include 'serial' => 'HALAEK123123' }
    its(['rows', 0, 'status_label']) { should include 'name' => 'Pending' }
    its('rows.first') { should include 'model_number' => 'MacPro4,1' }
    its('rows.first') { should include 'deleted_at' => nil }
  end
end

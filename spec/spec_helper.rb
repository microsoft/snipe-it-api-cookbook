require 'chefspec'
require 'chefspec/berkshelf'
require 'webmock/rspec'
require 'chef-vault/test_fixtures'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.alias_example_group_to :describe, type: :default_recipe
end

shared_context 'converged default recipe', type: :default_recipe do
  include ChefVault::TestFixtures.rspec_shared_context

  platform 'mac_os_x'
  platform 'ubuntu'
  platform 'windows'

  api_token = 'asdjlkhlskjha348298phluasf-.'
  api_instance = 'http://fakeymcfakerton.corp.mycompany.com'

  default_attributes['snipeit']['api']['instance'] = api_instance
  default_attributes['snipeit']['api']['token'] = api_token

  let(:headers) do
    {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{api_token}",
    }
  end

  endpoints = {
    hardware_endpoint: 'hardware',
    model_endpoint: 'models',
    category_endpoint: 'categories',
    manufacturer_endpoint: 'manufacturers',
    status_endpoint: 'statuslabels',
    location_endpoint: 'locations',
    fieldsets_endpoint: 'fieldsets',
  }

  endpoints.each do |key, value|
    let(key) do
      ::File.join(api_instance, 'api/v1', value)
    end
  end

  before do
    response_fixtures_path = 'spec/fixtures'
    response_fixtures = {
      model_endpoint => 'model_response.json',
      category_endpoint => 'category_response.json',
      manufacturer_endpoint => 'manufacturer_response.json',
      hardware_endpoint => 'hardware_response.json',
      status_endpoint => 'statuslabel_response.json',
      location_endpoint => 'location_response.json',
    }
    serial_numbers = %w(W81123456789 W80123456789 C0123456789)

    serial_numbers.each do |serial|
      stub_request(:get, "#{hardware_endpoint}/byserial/#{serial}")
    end

    response_fixtures.each do |endpoint, fixture|
      stub_request(:get, endpoint).to_return(
        body: IO.read(
          ::File.join(response_fixtures_path, fixture)
        )
      )
    end

    stub_request(:get, fieldsets_endpoint)
      .to_return(status: 200)
  end
end

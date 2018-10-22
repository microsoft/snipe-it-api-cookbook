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

  api_token = 'asdjlkhlskjha348298phluasf-.'
  api_instance = 'http://fakeymcfakerton.corp.mycompany.com'

  platform 'mac_os_x'
  platform 'ubuntu'
  platform 'windows'

  default_attributes['snipeit']['api']['instance'] = api_instance
  default_attributes['snipeit']['api']['token'] = api_token

  let(:headers) do
    {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{api_token}",
    }
  end

  before do
    stub_request(:get, "#{api_instance}/api/v1/models")
      .to_return(body: IO.read('./spec/fixtures/model_response.json'))

    stub_request(:get, "#{api_instance}/api/v1/categories")
      .to_return(body: IO.read('./spec/fixtures/category_response.json'))

    stub_request(:get, "#{api_instance}/api/v1/manufacturers")
      .to_return(body: IO.read('./spec/fixtures/manufacturer_response.json'))

    stub_request(:get, "#{api_instance}/api/v1/fieldsets")
      .to_return(status: 200)

    stub_request(:get, "#{api_instance}/api/v1/hardware")
      .to_return(body: IO.read('./spec/fixtures/hardware_response.json'))

    stub_request(:get, "#{api_instance}/api/v1/statuslabels")
      .to_return(body: IO.read('./spec/fixtures/statuslabel_response.json'))

    stub_request(:get, "#{api_instance}/api/v1/locations")
      .to_return(body: IO.read('./spec/fixtures/location_response.json'))
  end
end

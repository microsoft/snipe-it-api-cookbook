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
  config.fail_fast = true
  config.expect_with :rspec do |c|
    c.max_formatted_output_length = nil
  end
end

shared_context 'converged default recipe', type: :default_recipe do
  include ChefVault::TestFixtures.rspec_shared_context

  platform 'mac_os_x'
  platform 'ubuntu'
  platform 'windows'

  default_attributes['snipeit']['api']['instance'] = 'http://fakeymcfakerton.corp.mycompany.com'
  default_attributes['snipeit']['api']['token'] = 'asdjlkhlskjha348298phluasf-.'

  let(:headers) do
    {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer asdjlkhlskjha348298phluasf-.',
    }
  end

  let(:empty_response) do
    { total: 0, rows: [] }.to_json
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
      ::File.join('http://fakeymcfakerton.corp.mycompany.com', 'api/v1', value)
    end
  end

  before do
    stub_request(:get, "#{location_endpoint}?search=Building%201")
      .to_return(
        body: {
          total: 1,
          rows: [
            {
              id: 1,
              name: 'Building 1',
              address: '16011 NE 36th Way',
              city: 'Redmond',
              state: 'WA',
              country: 'US',
              zip: '98052',
              currency: 'USD',
            },
          ],
        }.to_json
      )
    stub_request(:get, "#{model_endpoint}?search=MacPro4,1")
      .to_return(
        body: {
          total: 1,
          rows: [
            {
              id: 4,
              name: 'Mac Pro (Early 2009)',
              manufacturer: {
                id: 7,
                name: 'Apple',
              },
              model_number: 'MacPro4,1',
              category: {
                id: 2,
                name: 'macOS - Desktop',
              },
            },
          ],
        }.to_json
      )

    stub_request(:get, "#{manufacturer_endpoint}?search=Apple")
      .to_return(
        body: {
          total: 1,
          rows: [
            {
              id: 4,
              name: 'Apple',
              url: 'https://www.apple.com',
            },
          ],
        }.to_json
      )

    stub_request(:get, "#{manufacturer_endpoint}?search=Dell")
      .to_return(body: empty_response)
  end
end

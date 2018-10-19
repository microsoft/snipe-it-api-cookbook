require 'chefspec'
require 'chefspec/berkshelf'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.alias_example_group_to :describe, type: :default_recipe
end

shared_context 'converged default recipe', type: :default_recipe do
  platform 'mac_os_x'
  platform 'ubuntu'
  platform 'windows'

  default_attributes['snipeit']['api']['instance'] = 'http://fakeymcfakerton.corp.mycompany.com'
  default_attributes['snipeit']['api']['token'] = 'asdjlkhlskjha348298phluasf-.'
  default_attributes['chef-vault']['databag_fallback'] = true

  before do
    url = 'http://fakeymcfakerton.corp.mycompany.com/api/v1'

    stub_request(:get, "#{url}/models")
      .to_return(body: IO.read('./spec/fixtures/model_response.json'))
    stub_request(:get, "#{url}/categories")
      .to_return(body: IO.read('./spec/fixtures/category_response.json'))
    stub_request(:get, "#{url}/manufacturers")
      .to_return(body: IO.read('./spec/fixtures/manufacturer_response.json'))
    stub_request(:get, "#{url}/fieldsets")
      .to_return(status: 200)
    stub_request(:get, "#{url}/hardware")
      .to_return(body: IO.read('./spec/fixtures/hardware_response.json'))
    stub_request(:get, "#{url}/statuslabels")
      .to_return(body: IO.read('./spec/fixtures/statuslabel_response.json'))
    stub_request(:get, "#{url}/locations")
      .to_return(body: IO.read('./spec/fixtures/location_response.json'))
    stub_data_bag('snipe-it').and_return(['api'])
    stub_data_bag_item('snipe-it', 'api').and_return({key: 'asdjlkhlskjha348298phluasf-.'})

    allow(Chef::DataBagItem).to receive(:load).and_return({key: 'asdjlkhlskjha348298phluasf-.'})
  end
end

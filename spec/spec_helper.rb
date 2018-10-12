require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/sugar'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.alias_example_group_to :describe, type: :default_recipe
end

shared_context 'converged default recipe', type: :default_recipe do
  default_attributes['snipeit']['api']['instance'] = 'http://fakeymcfakerton.corp.mycompany.com'
  default_attributes['snipeit']['api']['token'] = 'asdjlkhlskjha348298phluasf-.'
  before do
    allow(Chef::Sugar).to receive(:mac_os_x?).and_return(true)
    stub_request(:get, 'http://fakeymcfakerton.corp.mycompany.com/api/v1/models')
      .to_return(body: IO.read('./spec/fixtures/model_response.json'), status: 200)
    stub_request(:get, 'http://fakeymcfakerton.corp.mycompany.com/api/v1/categories')
      .to_return(body: IO.read('./spec/fixtures/category_response.json'), status: 200)
    stub_request(:get, 'http://fakeymcfakerton.corp.mycompany.com/api/v1/manufacturers')
      .to_return(body: IO.read('./spec/fixtures/manufacturer_response.json'), status: 200)
  end
end

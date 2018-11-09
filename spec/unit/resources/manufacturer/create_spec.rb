require 'spec_helper'

shared_examples 'manufacturer' do
  step_into :manufacturer
  recipe do
    manufacturer 'Apple' do
      token chef_vault_item('snipe-it', 'api')['key']
      url node['snipeit']['api']['instance']
      action :create
    end

    manufacturer 'Dell' do
      token chef_vault_item('snipe-it', 'api')['key']
      url node['snipeit']['api']['instance']
      action :create
    end
  end
end

describe 'snipeit_api::manufacturer - create action' do
  url = 'http://fakeymcfakerton.corp.mycompany.com/api/v1/manufacturers'
  include_examples 'manufacturer'
  context 'when the manufacturer exists' do
    it {
      is_expected.to_not post_http_request('create manufacturer[Apple]')
        .with(url: url, headers: headers)
    }
  end

  context 'when the manufacturer does not exist' do
    message = {
      name: 'Dell',
    }
    it {
      is_expected.to post_http_request('create manufacturer[Dell]')
        .with(url: url, message: message.to_json, headers: headers)
    }
  end
end

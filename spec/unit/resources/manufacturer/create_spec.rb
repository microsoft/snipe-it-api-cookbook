require 'spec_helper'

describe 'snipeit_api::manufacturer - create action' do
  step_into :manufacturer

  context 'when the manufacturer exists' do
    recipe do
      manufacturer 'Apple' do
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
        action :create
      end
    end

    it { is_expected.to_not post_http_request('create manufacturer[Apple]') }
  end

  context 'when the manufacturer does not exist' do
    recipe do
      manufacturer 'Dell' do
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
        action :create
      end
    end

    it {
      is_expected.to post_http_request('create manufacturer[Dell]')
        .with(
          url: manufacturer_endpoint,
          message: { name: 'Dell' }.to_json,
          headers: headers
        )
    }
  end
end

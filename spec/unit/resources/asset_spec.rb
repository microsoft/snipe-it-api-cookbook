require 'spec_helper'

shared_examples 'asset' do
  platform 'mac_os_x'
  platform 'ubuntu'
  step_into :asset

  recipe do
    api_token = node['snipeit']['api']['token']

    asset '1234567' do
      status 'Pending'
      model 'Mac Pro (Early 2009)'
      token api_token
    end

    asset '0000000' do
      status 'Pending'
      model 'Mac Pro (Early 2009)'
      token api_token
    end
  end
end

describe 'lab_core::asset' do
  include_examples 'asset'
  context 'when the model exists' do
    it {
      is_expected.to_not post_http_request('create asset[1234567]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/hardware',
        message: {
          asset_tag: '1234567',
          status_id: 1,
          model_id: 4,
        }.to_json
      )
    }
  end

  context 'when the model does not exist' do
    it {
      is_expected.to post_http_request('create asset[0000000]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/hardware',
        message: {
          asset_tag: '0000000',
          status_id: 1,
          model_id: 4,
        }.to_json
      )
    }
  end
end

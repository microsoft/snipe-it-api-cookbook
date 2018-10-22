require 'spec_helper'

shared_examples 'asset' do
  step_into :asset
  recipe do
    asset '1234567' do
      serial_number 'W80123456789'
      status 'Pending'
      model 'Mac Pro (Early 2009)'
    end

    asset '0000000' do
      serial_number 'W81123456789'
      status 'Pending'
      model 'Mac Pro (Early 2009)'
      location 'Building 1'
    end
  end
end

describe 'lab_core::asset' do
  url = 'http://fakeymcfakerton.corp.mycompany.com/api/v1/hardware'
  include_examples 'asset'
  context 'when the model exists' do
    it {
      is_expected.to_not post_http_request('create asset[1234567]')
        .with(url: url, headers: headers)
    }
  end

  context 'when the model does not exist' do
    message = {
      asset_tag: '0000000',
      serial: 'W81123456789',
      status_id: 1,
      model_id: 4,
      location_id: 1
    }

    it {
      is_expected.to post_http_request('create asset[0000000]')
        .with(url: url, message: message.to_json, headers: headers)
    }
  end
end

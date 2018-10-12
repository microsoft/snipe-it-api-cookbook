require 'spec_helper'

shared_examples 'manufacturer' do
  recipe do
    api_token = node['snipeit']['api']['token']

    manufacturer 'Apple' do
      website 'https://www.apple.com'
      token api_token
    end

    manufacturer 'Dell' do
      token api_token
    end
  end
end

describe 'lab_core::manufacturer' do
  platform 'mac_os_x'
  step_into :manufacturer
  include_examples 'manufacturer'
  context 'when the manufacturer exists' do
    it {
      is_expected.to_not post_http_request('create manufacturer[Apple]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/manufacturers',
        message: { name: 'Apple', url: 'https://www.apple.com' }.to_json
      )
    }
  end

  context 'when the manufacturer does not exist' do
    it {
      is_expected.to post_http_request('create manufacturer[Dell]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/manufacturers',
        message: { name: 'Dell', url: nil }.to_json
      )
    }
  end
end

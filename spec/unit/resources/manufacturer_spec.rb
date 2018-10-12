require 'spec_helper'

shared_examples 'create Apple manufacturer' do
  recipe do
    manufacturer 'Apple' do
      website 'https://www.apple.com'
    end

    manufacturer 'Spaghetti'
  end
end

describe 'lab_core::manufacturer' do
  platform 'mac_os_x'
  step_into :manufacturer
  before do
    allow(Chef::Sugar).to receive(:mac_os_x?).and_return(true)
    stub_request(:get, 'http://fakeymcfakerton.corp.mycompany.com/api/v1/manufacturers')
      .to_return(body: IO.read('./spec/fixtures/manufacturer_response.json'), status: 200)
  end

  include_examples 'create Apple manufacturer'

  context 'when the manufacturer does not exist' do
    it {
      is_expected.to post_http_request('create manufacturer[Apple]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/manufacturers',
        message: { name: 'Apple', url: 'https://www.apple.com' }.to_json
      )
    }
  end

  context 'when the manufacturer exists' do
    include_examples 'create Apple manufacturer'

    it {
      is_expected.to_not post_http_request('create manufacturer[Spaghetti]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/manufacturers',
        message: { name: 'Spaghetti', url: 'https://www.apple.com' }.to_json
      )
    }
  end
end

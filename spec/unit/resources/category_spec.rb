require 'spec_helper'

shared_examples 'category' do
  recipe do
    api_token = node['snipeit']['api']['token']

    category 'Desktop - macOS' do
      category_type 'asset'
      token api_token
    end

    category 'Misc Software' do
      token api_token
    end
  end
end

describe 'lab_core::category' do
  platform 'mac_os_x'
  step_into :category
  before do
    allow(Chef::Sugar).to receive(:mac_os_x?).and_return(true)
    stub_request(:get, 'http://fakeymcfakerton.corp.mycompany.com/api/v1/categories')
      .to_return(body: IO.read('./spec/fixtures/category_response.json'), status: 200)
  end

  include_examples 'category'

  context 'when the category does not exist' do
    it {
      is_expected.to post_http_request('create category[Desktop - macOS]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/categories',
        message: { name: 'Desktop - macOS', category_type: 'asset' }.to_json
      )
    }
  end

  context 'when the category exists' do
    it {
      is_expected.to_not post_http_request('create category[Misc Software]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/categories',
        message: { name: 'Misc Software', category_type: 'license' }.to_json
      )
    }
  end
end

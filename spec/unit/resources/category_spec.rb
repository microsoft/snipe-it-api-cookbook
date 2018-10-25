require 'spec_helper'

shared_examples 'category' do
  step_into :category
  recipe do
    api_token = node['snipeit']['api']['token']

    category 'Desktop - macOS' do
      category_type 'asset'
      token api_token
    end

    category 'Misc Software' do
      category_type 'license'
      token api_token
    end
  end
end

describe 'lab_core::category' do
  url = 'http://fakeymcfakerton.corp.mycompany.com/api/v1/categories'
  include_examples 'category'
  context 'when the category does not exist' do
    message = {
      name: 'Desktop - macOS',
      category_type: 'asset',
    }

    it {
      is_expected.to post_http_request('create category[Desktop - macOS]')
        .with(url: url, message: message.to_json, headers: headers)
    }
  end

  context 'when the category exists' do
    it {
      is_expected.to_not post_http_request('create category[Misc Software]')
        .with(url: url, headers: headers)
    }
  end
end

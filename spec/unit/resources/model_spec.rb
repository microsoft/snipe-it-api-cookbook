require 'spec_helper'

shared_examples 'model' do
  recipe do
    api_token = node['snipeit']['api']['token']

    model 'Mac Pro (Early 2009)' do
      manufacturer 'Apple'
      category 'macOS - Desktop'
      model_number 'MacPro4,1'
      token api_token
    end
  end
end

describe 'lab_core::model' do
  platform 'mac_os_x'
  step_into :model
  include_examples 'model'
  context 'when the model does not exist' do
    it {
      is_expected.to post_http_request('create model[Mac Pro (Early 2009)]').with(
        url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/models',
        message: {
          name: 'Mac Pro (Early 2009)',
          model_number: 'MacPro4,1',
          category_id: 2,
          manufacturer_id: 4,
        }.to_json
      )
    }
  end
end

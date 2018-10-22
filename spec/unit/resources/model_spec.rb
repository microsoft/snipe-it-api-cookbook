require 'spec_helper'

shared_examples 'model' do
  step_into :model
  recipe do
    api_token = node['snipeit']['api']['token']
    model 'Mac Pro (Early 2009)' do
      manufacturer 'Apple'
      category 'macOS - Desktop'
      model_number 'MacPro4,1'
      token api_token
    end

    model 'HAL 9000' do
      manufacturer 'University of Illinois'
      category 'Windows - Desktop'
      model_number 'HAL9000'
    end
  end
end

describe 'lab_core::model' do
  url = 'http://fakeymcfakerton.corp.mycompany.com/api/v1/models'
  include_examples 'model'

  context 'when the model does exist' do
    it {
      is_expected.to_not post_http_request('create model[Mac Pro (Early 2009)]')
        .with(url: url, headers: headers)
    }
  end

  context 'when the model does not exist' do
    message = {
      name: 'HAL 9000',
      model_number: 'HAL9000',
      category_id: 3,
      manufacturer_id: 3,
    }

    it {
      is_expected.to post_http_request('create model[HAL 9000]')
        .with(url: url, message: message.to_json, headers: headers)
    }
  end
end

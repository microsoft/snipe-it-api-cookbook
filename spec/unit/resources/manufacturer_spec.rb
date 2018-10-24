require 'spec_helper'

shared_examples 'manufacturer' do
  step_into :manufacturer
  recipe do
    manufacturer 'Apple' do
      website 'https://www.apple.com'
    end

    manufacturer 'Dell' do
      token 'asdjlkhlskjha348298phluasf-.'
    end
  end
end

describe 'lab_core::manufacturer' do
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

require 'spec_helper'

describe 'snipeit_api::location' do
  step_into :location
  context 'when the model exists' do
    recipe do
      location 'Building 1' do
        address '16011 NE 36th Way'
        city 'Redmond'
        state 'WA'
        zip '98052'
        currency 'USD'
        token node['snipeit']['api']['token']
        url node['snipeit']['api']['instance']
      end
    end
    it { is_expected.to_not post_http_request('create location[Building 1]') }
  end

  context 'when the model does not exist' do
    recipe do
      location 'Building 2' do
        address '16021 NE 36th St'
        city 'Redmond'
        state 'WA'
        zip '98052'
        currency 'USD'
        token node['snipeit']['api']['token']
        url node['snipeit']['api']['instance']
      end
    end

    it {
      is_expected.to post_http_request('create location[Building 2]')
        .with(
          url: location_endpoint,
          message: {
            name: 'Building 2',
            address: '16021 NE 36th St',
            state: 'WA',
            country: 'US',
            zip: '98052',
            currency: 'USD',
          }.to_json,
          headers: headers)
    }
  end
end

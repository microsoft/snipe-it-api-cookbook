require 'spec_helper'

describe 'lab_core::asset' do
  step_into :asset

  context 'when the asset exists' do
    recipe do
      asset '1234567' do
        serial_number 'W80123456789'
        status 'Pending'
        model 'MacPro4,1'
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
      end
    end

    it { is_expected.to_not post_http_request('create asset[1234567]') }
  end

  context 'when the asset does not exist' do
    recipe do
      asset '0000000' do
        serial_number 'W81123456789'
        model 'MacPro4,1'
        location 'Building 1'
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
      end
    end

    message = {
      asset_tag: '0000000',
      serial: 'W81123456789',
      status_id: 1,
      model_id: 4,
      location_id: 1,
    }

    it {
      is_expected.to post_http_request('create asset[0000000]')
        .with(
          url: 'http://fakeymcfakerton.corp.mycompany.com/api/v1/hardware',
          message: message.to_json,
          headers: headers
        )
    }
  end

  context 'when the location does not exist' do
    recipe do
      asset '1' do
        serial_number 'C0123456789'
        status 'Pending'
        model 'MacPro4,1'
        location 'Building 42'
        token node['snipeit']['api']['token']
        url node['snipeit']['api']['instance']
      end
    end

    it 'raises an exception' do
      expect { chef_run }.to raise_error(Location::DoesNotExistError)
    end
  end

  context 'when the status label, and model does not exist in the database' do
    recipe do
      asset '1' do
        serial_number 'C0123456789'
        status 'Recycled'
        model 'MacPro4,1'
        location 'Building 1'
        token node['snipeit']['api']['token']
        url node['snipeit']['api']['instance']
      end
    end

    it 'raises an exception' do
      expect { chef_run }.to raise_error(Status::DoesNotExistError)
    end
  end

  context 'when the model does not exist' do
    recipe do
      asset '1' do
        serial_number 'C0123456789'
        status 'Pending'
        model 'MacPro6,1'
        location 'Building 1'
        token node['snipeit']['api']['token']
        url node['snipeit']['api']['instance']
      end
    end

    it 'raises an exception' do
      expect { chef_run }.to raise_error(Model::DoesNotExistError)
    end
  end
end

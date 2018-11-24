require 'spec_helper'

describe 'snipeit_api::asset - create action' do
  step_into :asset
  before do
    stub_request(:get, "#{status_endpoint}?search=Pending")
      .to_return(
        body: {
          total: 1,
          rows: [
            {
              id: 1,
              name: 'Pending',
              type: 'pending',
              notes: 'These assets are not yet ready to be deployed, usually because of configuration or waiting on parts.',
            },
          ],
        }.to_json
      )
    stub_request(:get, "#{hardware_endpoint}/byserial/C0123456789")
      .to_return(body: empty_response)
  end

  context 'when the asset exists' do
    before do
      stub_request(:get, "#{hardware_endpoint}/byserial/W80123456789")
        .to_return(
          body: {
            total: 1,
            rows: [
              {
                id: 1,
                name: 'Magic-Machine',
                serial: 'W80123456789',
              },
            ],
          }.to_json
        )
    end

    recipe do
      asset 'asset exists' do
        machine_name 'Magic-Machine'
        serial_number 'W80123456789'
        status 'Pending'
        model 'MacPro4,1'
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
      end
    end

    it { is_expected.to_not post_http_request('create asset[Magic-Machine]') }
  end

  context 'when the asset does not exist' do
    before do
      stub_request(:get, "#{hardware_endpoint}/byserial/W81123456789")
        .to_return(body: empty_response)
    end

    recipe do
      asset 'create a machine' do
        machine_name 'Does Not Exist'
        asset_tag '0000000'
        serial_number 'W81123456789'
        model 'MacPro4,1'
        location 'Building 1'
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
      end
    end

    message = {
      rtd_location_id: 1,
      name: 'Does Not Exist',
      asset_tag: '0000000',
      serial: 'W81123456789',
      status_id: 1,
      model_id: 4,
    }

    it {
      is_expected.to post_http_request('create Does Not Exist')
        .with(
          url: hardware_endpoint,
          message: message.to_json,
          headers: headers
        )
    }
  end

  context 'when the location does not exist' do
    before do
      stub_request(:get, "#{location_endpoint}?search=Building%2042")
        .to_return(body: empty_response)
    end

    recipe do
      asset 'creating asset' do
        machine_name 'Does Not Exist'
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

  context 'when the status label does not exist in the database' do
    before do
      stub_request(:get, "#{status_endpoint}?search=Recycled")
        .to_return(body: empty_response)
    end

    recipe do
      asset 'creating asset' do
        machine_name 'Does Not Exist'
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
    before do
      stub_request(:get, "#{model_endpoint}?search=MacPro6,1")
        .to_return(body: empty_response)
    end

    recipe do
      asset 'creating asset' do
        machine_name 'Does Not Exist'
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

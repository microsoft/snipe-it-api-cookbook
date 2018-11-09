require 'spec_helper'

describe 'snipeit_api::manufacturer - delete action' do
  step_into :manufacturer

  context 'when the manufacturer exists' do
    recipe do
      manufacturer 'Apple' do
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
        action :delete
      end
    end

    it { is_expected.to delete_http_request('delete Apple') }
  end

  context 'when the manufacturer does not exist' do
    recipe do
      manufacturer 'Apple' do
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
        action :delete
      end
    end

    it { is_expected.to_not delete_http_request('delete Dell') }
  end
end
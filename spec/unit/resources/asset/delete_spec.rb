require 'spec_helper'

describe 'snipeit_api::asset - delete action' do
  step_into :asset

  context 'when the asset exists' do
    recipe do
      asset 'Magic-Machine' do
        token chef_vault_item('snipe-it', 'api')['key']
        url node['snipeit']['api']['instance']
        action :delete
      end
    end

    it { is_expected.to delete_http_request('delete asset[Magic-Machine]') }
  end
end

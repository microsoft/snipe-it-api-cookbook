require 'spec_helper'

describe 'snipeit_api::category' do
  step_into :category
  context 'when the category does not exist' do
    recipe do
      category 'Desktop - macOS' do
        category_type 'asset'
        token node['snipeit']['api']['token']
        url node['snipeit']['api']['instance']
      end
    end

    it {
      is_expected.to post_http_request('create category[Desktop - macOS]')
        .with(
          url: category_endpoint,
          message: {
            name: 'Desktop - macOS',
            category_type: 'asset',
          }.to_json,
          headers: headers)
    }
  end

  context 'when the category exists' do
    recipe do
      category 'Misc Software' do
        category_type 'license'
        token node['snipeit']['api']['token']
        url node['snipeit']['api']['instance']
      end
    end
    it { is_expected.to_not post_http_request('create category[Misc Software]') }
  end
end

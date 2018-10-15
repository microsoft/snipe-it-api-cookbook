require 'uri'
require 'net/http'
require 'json'

module LabCore
  module SnipeIT
    module API
      class Endpoint
        attr_reader :url
        attr_reader :manufacturers
        attr_reader :models
        attr_reader :categories
        attr_reader :fieldsets
        attr_reader :assets
        attr_reader :status

        def initialize(url, token)
          @url = url
          @token = token
          @manufacturers = snipeit_api('manufacturers')
          @models = snipeit_api('models')
          @categories = snipeit_api('categories')
          @fieldsets = snipeit_api('fieldsets')
          @assets = snipeit_api('hardware')
          @status = snipeit_api('statuslabels')
        end

        def snipeit_api(resource)
          ::File.join(@url, "api/v1/#{resource}")
        end

        def headers
          {
            'Authorization': "Bearer #{@token}",
            'Content-Type': 'application/json',
          }
        end
      end

      class Get < Net::HTTP::Get
        def initialize(url, token, name)
          @url = URI(url)
          @name = name
          super @url, {
            'Authorization': "Bearer #{token}",
            'Content-Type': 'application/json',
          }
        end

        def response
          request = self
          response = Net::HTTP.start(@url.host, @url.port) { |http| http.request request }
          JSON.load(response.body)
        end

        def asset_tag_exists?
          response['rows'].any? { |m| m['asset_tag'] == @name }
        end

        def name_exists?
          response['rows'].any? { |m| m['name'] == @name }
        end

        def current_asset
          response['rows'].find { |record| record['asset_tag'] == @name }
        end

        def current_record
          response['rows'].find { |record| record['name'] == @name }
        end
      end
    end
  end
end

Chef::Recipe.include LabCore
Chef::Resource.include LabCore

require 'uri'
require 'net/http'
require 'json'

module LabCore
  module SnipeIT
    module API
      class Endpoint
        def initialize(url, token, resource)
          @url = url
          @token = token
          @resource = resource
        end

        def uri
          ::File.join(@url, "api/v1/#{@resource}")
        end

        def headers
          {
            'Authorization': "Bearer #{@token}",
            'Content-Type': 'application/json',
          }
        end
      end

      class Get < Net::HTTP::Get
        attr_reader :endpoint

        def initialize(url, token, resource, name)
          @endpoint = Endpoint.new(url, token, resource)
          @headers = @endpoint.headers
          @url = URI(@endpoint.uri)
          @name = name
          super @url, @headers
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

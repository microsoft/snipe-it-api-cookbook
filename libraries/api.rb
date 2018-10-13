require 'uri'
require 'net/http'
require 'json'

module LabCore
  module SnipeIT
    module API
      class Endpoint
        attr_reader :url
        attr_reader :manufacturers_endpoint
        attr_reader :models_endpoint
        attr_reader :categories_endpoint
        attr_reader :fieldsets_endpoint

        def initialize(url)
          @url = url
          @manufacturers_endpoint = snipeit_endpoint(@url, 'manufacturers')
          @models_endpoint = snipeit_endpoint(@url, 'models')
          @categories_endpoint = snipeit_endpoint(@url, 'categories')
          @fieldsets_endpoint = snipeit_endpoint(@url, 'fieldsets')
        end

        def snipeit_endpoint(url, resource)
          ::File.join(url, "api/v1/#{resource}")
        end
      end

      class Get < Net::HTTP::Get
        def initialize(url, token)

          @url = URI(url)
          super @url
          @token = token
        end

        def response
          request = self
          request['Authorization'] = "Bearer #{@token}"
          request['Content-Type'] = 'application/json'
          response = Net::HTTP.start(@url.host, @url.port) { |http| http.request request }
          response.body
        end
      end

      def authorization_headers(token)
        {
          'Authorization': "Bearer #{token}",
          'Content-Type': 'application/json',
        }
      end

      def response_hash(response)
        JSON.load(response)
      end

      def record_exists?(http_response, name)
        response = response_hash(http_response)
        response['rows'].any? { |m| m['name'] == name }
      end

      def current_record(http_response, desired_record)
        if record_exists?(http_response, desired_record)
          response = response_hash(http_response)
          response['rows'].find { |record| record['name'] == desired_record }
        end
      end
    end
  end
end

Chef::Recipe.include LabCore
Chef::Resource.include LabCore

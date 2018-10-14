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

        def initialize(url, token)
          @url = url
          @token = token
          @manufacturers = snipeit_api(@url, 'manufacturers')
          @models = snipeit_api(@url, 'models')
          @categories = snipeit_api(@url, 'categories')
          @fieldsets = snipeit_api(@url, 'fieldsets')
        end

        def snipeit_api(url, resource)
          ::File.join(url, "api/v1/#{resource}")
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

        def record_exists?
          response['rows'].any? { |m| m['name'] == @name }
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

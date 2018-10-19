require 'uri'
require 'net/http'
require 'json'

module SnipeIT
  module API
    class Endpoint
      def initialize(url, token)
        @url = url
        @token = token
      end

      def snipeit_url(resource_type)
        url = ::File.join(@url, "api/v1/#{resource_type}")
      end

      def headers
        {
          'Authorization': "Bearer #{@token}",
          'Content-Type': 'application/json',
        }
      end
    end

    class Get < Net::HTTP::Get
      def initialize(url, headers)
        @uri = URI(url)
        super @uri, headers
      end

      def response
        request = self
        response = Net::HTTP.start(@uri.host, @uri.port) { |http| http.request request }
        JSON.load(response.body)
      end
    end
  end
end

Chef::Recipe.include SnipeIT
Chef::Resource.include SnipeIT

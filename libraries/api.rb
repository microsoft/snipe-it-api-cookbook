require 'uri'
require 'net/http'
require 'json'

module SnipeIT
  module API
    class Get < Net::HTTP::Get
      def initialize(url, token, resource)
        @url = url
        @resource = resource
        @uri = URI(snipeit_url)
        @token = token
        super @uri, headers
      end

      def headers
        {
          'Authorization': "Bearer #{@token}",
          'Content-Type': 'application/json',
        }
      end

      def snipeit_url
        ::File.join(@url, "api/v1/#{@resource}")
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

require 'uri'
require 'net/http'
require 'json'

module SnipeIT
  module API
    class Endpoint
      def initialize(url, token, type, query)
        @token = token
        @url = url
        @type = type
        @query = query
      end

      def join_url
        ::File.join(@url, 'api', 'v1', @type)
      end

      def uri
        if @type == 'hardware'
          uri = URI(::File.join(join_url, 'byserial', @query))
        elsif @query.is_a? Hash
          uri = URI(join_url)
          uri.query = URI.encode_www_form(@query)
        end

        uri
      end

      def headers
        {
          'Authorization': "Bearer #{@token}",
          'Content-Type': 'application/json',
        }
      end
    end

    class Get < Net::HTTP::Get
      def initialize(endpoint)
        @uri = endpoint.uri
        super @uri, endpoint.headers
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

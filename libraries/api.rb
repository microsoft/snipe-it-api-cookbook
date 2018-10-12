require 'uri'
require 'net/http'
require 'json'

module LabCore
  module SnipeIT
    module API
      def authorization_headers(token)
        {
          'Authorization': "Bearer #{token}",
          'Content-Type': 'application/json',
        }
      end

      def snipeit_endpoint(url, resource)
        ::File.join(url, "api/v1/#{resource}")
      end

      def http_get(url, token)
        uri = URI(url)
        request = Net::HTTP::Get.new uri
        request['Authorization'] = "Bearer #{token}"
        request['Content-Type'] = 'application/json'
        response = Net::HTTP.start(uri.host, uri.port) { |http| http.request request }
        response.body
      end

      def response_hash(response)
        JSON.load(response)
      end

      def record_exists?(http_response, name)
        response = response_hash(http_response)
        response['rows'].any? { |m| m['name'] == name }
      end

      def current_record(http_response, desired_record)
        response = response_hash(http_response)
        response['rows'].find { |record| record['name'] == desired_record }
      end
    end
  end
end

Chef::Recipe.include LabCore
Chef::Resource.include LabCore

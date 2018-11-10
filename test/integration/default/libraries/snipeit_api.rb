class SnipeITAPI < Inspec.resource(1)
  name 'snipeit_api'

  def initialize(url, token)
    @url = url
    @token = token
  end

  def headers
    { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{@token}" }
  end

  def response(type, name)
    inspec.http("#{@url}/api/v1/#{type}", headers: headers, params: {search: URI.encode(name)})
  end
end
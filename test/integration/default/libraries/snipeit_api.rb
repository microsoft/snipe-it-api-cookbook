class SnipeITAPI < Inspec.resource(1)
  name 'snipeit_api'

  def initialize(url, token)
    @url = url
    @token = token
  end

  def headers
    {
      'Authorization' => "Bearer #{@token}",
      'Content-Type' => 'application/json',
    }
  end

  def response(type, name)
    inspec.http(
      ::File.join(@url, 'api', 'v1', type),
      headers: headers,
      params: { search: URI.encode(name) }
    )
  end
end

include SnipeIT::API

class Status
  def initialize(url, token, status_label)
    @status_label = status_label
    endpoint = Endpoint.new(url, token, 'statuslabels', search: status_label)
    @status = Get.new(endpoint)
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    if @status.response['rows'].empty?
      raise Status::DoesNotExistError, "#{@status_label} status does not exist in the database!"
    else
      @status.response['rows'].first
    end
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  end
end

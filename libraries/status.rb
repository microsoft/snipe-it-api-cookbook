include SnipeIT::API

class Status
  def initialize(endpoint, status_label)
    @status_label = status_label
    @status = Get.new(endpoint.snipeit_url('statuslabels'), endpoint.headers)
  end

  class DoesNotExistError < StandardError
  end

  def current_value
    @status.response['rows'].find do |status|
      status['name'] == @status_label
    end
  end

  def name
    current_value['name']
  end

  def id
    current_value['id']
  rescue NoMethodError
    raise Status::DoesNotExistError, "#{@status_label} status does not exist in the database!"
  end

  def exists?
    @status.response['rows'].any? do |status|
      status['name'] == @status_label
    end
  end
end

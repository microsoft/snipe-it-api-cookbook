include SnipeIT::API

class Status
  def initialize(url, token, status_label)
    @status_label = status_label
    @status = Get.new(url, token, 'statuslabels')
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
  end

  def exists?
    @status.response['rows'].any? do |status|
      status['name'] == @status_label
    end
  end
end

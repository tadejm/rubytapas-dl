require "net/http"

class Feed
  FEED_URL = "https://rubytapas.dpdcart.com/feed"

  def initialize(username, password)
    @username, @password = username, password
    @uri = URI.parse(FEED_URL)
  end

  def body
    response.body
  end

  def response
    @response ||= http.request(request)
  end

  private

  def request
    Net::HTTP::Get.new(@uri.request_uri)
  end

  def http
    Net::HTTP.new(@uri.host, @uri.port).tap { |http| http.use_ssl = true }
  end

end

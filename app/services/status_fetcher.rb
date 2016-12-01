class StatusFetcher
  def self.call(services_hash)
    return {} if Configurations.sickbay_url.nil?

    uri = URI(Configurations.sickbay_url)

    uri.query = URI.encode_www_form(services_hash)

    response = Net::HTTP.get_response(uri)

    return {} unless response.is_a? Net::HTTPOK

    JSON.parse(response.body)
  rescue JSON::ParserError
    {}
  end
end

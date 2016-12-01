class OutageNotifier
  def self.call(service, codes)
    uri = URI(Configurations.doctor_url)

    Net::HTTP.post_form(
      uri,
      service_name: service.name,
      service_url: service.url,
      'codes[]' => codes
    )
  end
end

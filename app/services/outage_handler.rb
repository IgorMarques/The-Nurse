class OutageHandler
  def self.call(service, last_codes_received)
    OutageNotifier.call(service, last_codes_received)

    Outage.create(
      service: service,
      codes: last_codes_received
    )
  end
end

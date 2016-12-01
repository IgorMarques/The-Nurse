class ServicesStatusEvaluator
  def self.call(services = Service.active)
    services.each do |service|
      last_codes = service.statuses.last(Configurations.evaluating.entries_fetched).pluck(:code)

      bad_codes_count = 0

      last_codes.each do |code|
        bad_codes_count += 1 unless service.allowed_codes.include?(code)
      end

      if bad_codes_count >= Configurations.evaluating.entries_expected_to_be_ok
        OutageHandler.call(service, last_codes)
      end
    end
  end
end

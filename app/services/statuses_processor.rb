class StatusesProcessor
  def self.call(statuses)
    statuses.each do |name, code|
      service = Service.where(name: name).first

      next if service.nil?
      
      Status.create(
        service: service,
        code: code
      )
    end
  end
end

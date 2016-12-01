class ServicesStatusFetcher
   def self.call(services = Service.active)
     names_and_urls_hash = services.each_with_object({}) do |service, result|
       result[service.name] = service.url
     end

     statuses = StatusFetcher.call(names_and_urls_hash)

     StatusesProcessor.call(statuses)
   end
end

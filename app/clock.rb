require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  every Configurations.health_check_rate.minutes, 'service_status.fetch' do
    ServicesStatusFetcherWorker.perform_async
  end
end

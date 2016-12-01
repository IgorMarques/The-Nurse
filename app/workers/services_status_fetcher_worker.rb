class ServicesStatusFetcherWorker
  include Sidekiq::Worker

  def perform
    ServicesStatusFetcher.call
    ServicesStatusEvaluator.call
  end
end

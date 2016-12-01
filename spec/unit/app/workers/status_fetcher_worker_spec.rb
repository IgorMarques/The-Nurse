require 'rails_helper'

RSpec.describe ServicesStatusFetcherWorker do
  describe '.perform' do
    before do
      allow(ServicesStatusFetcher).to receive(:call)
      allow(ServicesStatusEvaluator).to receive(:call)
    end

    it 'calls ServicesStatusFetcher and ServicesStatusEvaluator' do
      described_class.new.perform

      expect(ServicesStatusFetcher).to have_received(:call).once
      expect(ServicesStatusEvaluator).to have_received(:call).once
    end
  end
end

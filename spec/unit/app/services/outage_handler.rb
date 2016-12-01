require 'rails_helper'

RSpec.describe OutageHandler do
  describe '#call' do
    before do
      allow(OutageNotifier).to receive(:call)
    end

    let(:service) do
      Service.create(
        name: 'ExampleService',
        url: 'www.example-service.com',
        allowed_codes: [200]
      )
    end

    let(:last_codes) do
      [200, 500, 500]
    end

    it 'notifies the outage' do
      described_class.call(service, last_codes)

      expect(OutageNotifier).to have_received(:call).with(service, last_codes)
    end

    it 'creates an outage' do
      expect {
        described_class.call(service, last_codes)
      }.to change(Outage, :count).by(1)
    end

    it 'creates an outage with the given service and status' do
      allow(Outage).to receive(:create)

      described_class.call(service, last_codes)

      expect(Outage)
        .to have_received(:create)
        .with(
          service: service,
          codes: last_codes
        )
    end
  end
end

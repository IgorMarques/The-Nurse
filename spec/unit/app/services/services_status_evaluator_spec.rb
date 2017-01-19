require 'rails_helper'

RSpec.describe ServicesStatusEvaluator do
  describe '#call' do
    before do
      allow(OutageHandler).to receive(:call)
    end

    let(:services) do
      [service1, service2]
    end

    let(:service1) do
      Service.create(
        name: 'ExampleService',
        url: 'http://http://www.example-service.com',
        allowed_codes: [200]
      )
    end

    let(:service2) do
      Service.create(
        name: 'AnotherExampleService',
        url: 'http://www.another-example-service.com',
        allowed_codes: [200]
      )
    end

    before do
      3.times do
        Status.create(
          code: 200,
          service: service1
        )
      end
    end

    context 'when the services are ok' do
      before do
        3.times do
          Status.create(
            code: 200,
            service: service2
          )
        end
      end

      it 'does not register an outage' do
        described_class.call(services)

        expect(OutageHandler).to_not have_received(:call)
      end
    end

    context 'when some services are not ok' do
      before do
        2.times do
          Status.create(
            code: 500,
            service: service2
          )
        end

        Status.create(
          code: 200,
          service: service2
        )
      end

      it 'registers an outage' do
        described_class.call(services)

        expect(OutageHandler).to have_received(:call).with(service2, [500, 500, 200])
      end
    end

    context 'when the number of statuses of a service is smaller than the number of entries expected to be ok' do
      before do
        Status.create(
          code: 200,
          service: service2
        )
      end

      it 'does not register an outage' do
        described_class.call([service2])

        expect(OutageHandler).to_not have_received(:call)
      end
    end
  end
end

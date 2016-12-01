require 'rails_helper'

RSpec.describe ServicesStatusFetcher do
  describe '#call' do
    before do
      allow(StatusFetcher).to receive(:call).and_return(statuses)

      allow(StatusesProcessor).to receive(:call)
    end

    let(:statuses) do
      {
        'ExampleService' => '200',
        'AnotherExampleService' => '200'
      }
    end

    let(:services) do
      [
        Service.new(
          name: 'ExampleService',
          url: 'www.example-service.com'
        ),
        Service.new(
          name: 'AnotherExampleService',
          url: 'www.another-example-service.com'
        )
      ]
    end

    it 'gets the statuses of the given services' do
      described_class.call(services)

      expect(StatusFetcher).to have_received(:call).with(
        {
          'ExampleService' => 'www.example-service.com',
          'AnotherExampleService' => 'www.another-example-service.com',
        }
      )
    end

    it 'processes the statuses of the given services' do
      described_class.call(services)

      expect(StatusesProcessor).to have_received(:call).with(statuses)
    end
  end
end

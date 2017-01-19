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
          url: 'http://www.example-service.com'
        ),
        Service.new(
          name: 'AnotherExampleService',
          url: 'http://www.another-example-service.com'
        )
      ]
    end

    it 'gets the statuses of the given services' do
      described_class.call(services)

      expect(StatusFetcher).to have_received(:call).with(
        {
          'ExampleService' => 'http://www.example-service.com',
          'AnotherExampleService' => 'http://www.another-example-service.com',
        }
      )
    end

    it 'processes the statuses of the given services' do
      described_class.call(services)

      expect(StatusesProcessor).to have_received(:call).with(statuses)
    end
  end
end

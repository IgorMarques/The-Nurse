require 'rails_helper'

RSpec.describe StatusFetcher do
  describe '#call' do
    let(:services) do
      {
        'ExampleService' => 'http://www.example-service.com',
        'SomeOtherService' => 'www.some-other-service.com',
      }
    end

    before do
      stub_request(:get, sickbay_url + '?ExampleService=http://www.example-service.com&SomeOtherService=www.some-other-service.com')
      .to_return(
        request_return
      )
    end

    let(:sickbay_url) do
      Configurations.sickbay_url
    end

    let(:request_return) do
      {
        body:
          {
            'ExampleService' => '200',
            'SomeOtherService' => '500'
          }.to_json
      }
    end

    context 'when the designated sickbay instance is set and available' do
      it 'returns the service status of a list of given services' do
        expect(described_class.call(services)).to eq(
          {
            'ExampleService' => '200',
            'SomeOtherService' => '500',
          }
        )
      end
    end

    context 'when there is no designated sickbay instance' do
      before do
        allow(Configurations).to receive(:sickbay_url).and_return nil
      end

      it 'returns an empty hash' do
        expect(described_class.call(services)).to eq({})
      end
    end

    context 'when the designated sickbay instance is not actually a sickbay instance' do
      before do
        allow(Configurations).to receive(:sickbay_url).and_return 'http://www.google.com'
      end

      let(:sickbay_url) do
        'http://www.google.com'
      end

      let(:request_return) do
        {
          body: '<html>Some Html</html>'
        }
      end

      it 'returns an empty hash' do
        expect(described_class.call(services)).to eq({})
      end
    end

    context 'when the designated sickbay instance is down' do
      let(:request_return) do
        {
          status: [500, "Internal Server Error"]
        }
      end

      it 'returns an empty hash' do
        expect(described_class.call(services)).to eq({})
      end
    end
  end
end

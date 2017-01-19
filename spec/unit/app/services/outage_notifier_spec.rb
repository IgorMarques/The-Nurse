require 'rails_helper'

RSpec.describe OutageNotifier do
  describe '#call' do
    let(:service) do
      Service.create(
        name: 'ExampleService',
        url: 'http://http://www.example-service.com',
        allowed_codes: [200]
      )
    end

    let(:codes) do
      ["200", "500", "500"]
    end

    before do
      stub_request(:post, Configurations.doctor_url).
         with(:body => {"codes"=> codes, "service_name"=>"ExampleService", "service_url"=>"http://http://www.example-service.com"})
    end

    it 'sends a POST call to your Doctor endpoint' do
      described_class.call(service, codes)
    end
  end
end

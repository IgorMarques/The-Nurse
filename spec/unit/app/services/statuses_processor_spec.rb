require 'rails_helper'

RSpec.describe StatusesProcessor do
  describe '#call' do
    context 'when sending a valid list of statuses' do
      let(:statuses) do
        {
          'ExampleService' => '200',
          'AnotherExampleService' => '200',
          'AnUnregisteredService' => '200'
        }
      end

      let!(:first_service) do
        Service.create(
          name: 'ExampleService',
          url: 'http://www.example-service.com'
        )
      end

      let!(:second_service) do
        Service.create(
          name: 'AnotherExampleService',
          url: 'http://www.another-example-service.com'
        )
      end

      it 'creates a Status entry for each existing service in the list' do
        expect {
          described_class.call(statuses)
        }.to change(Status, :count).by(2)
      end

      it 'creates a Status entry referencing the given existing services' do
        allow(Status).to receive(:create).twice

        described_class.call(statuses)

        expect(Status).to have_received(:create).with(service: first_service, code: '200')

        expect(Status).to have_received(:create).with(service: second_service, code: '200')
      end
    end

    context 'when sending an empty list of statuses' do
      it 'does not raise an error' do
        expect{ described_class.call( {} ) }.to_not raise_error
      end
    end
  end
end

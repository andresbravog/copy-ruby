require "spec_helper"

describe Copy::Request::Base do
  let(:consumer_key) { '_your_consumen_key_' }
  let(:consumer_secret) { '_your_consumen_secret_' }

  before :each do
    Copy.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  context "#perform" do
    it "performs an https request" do
      connection = double
      validator  = double
      allow(Copy::Request::Connection).to receive(:new).and_return(connection)
      allow(Copy::Request::Validator).to receive(:new).and_return(validator)

      expect(connection).to receive(:set_request_data)
      expect(connection).to receive(:request)
      expect(validator).to receive(:validated_data_for)

      Copy::Request::Base.new(nil).perform
    end
  end
end

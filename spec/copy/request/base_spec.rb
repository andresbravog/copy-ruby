require "spec_helper"

describe Copy::Request::Base do
  let(:consumer_key) { '_your_consumen_key_' }
  let(:consumer_secret) { '_your_consumen_secret_' }
  let(:info) { double(:info, session: session ) }
  let(:session) { double(:session, valid?: true ) }
  let(:request_base) { Copy::Request::Base.new(info) }
  let(:connection) { double(:connection) }
  let(:validator) { double(:validator) }

  before :each do
    allow(Copy::Request::Connection).to receive(:new).and_return(connection)
    allow(Copy::Request::Validator).to receive(:new).and_return(validator)
    Copy.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  describe "#perform" do
    it 'raises AuthenticationError if request is not valid' do
      allow(request_base).to receive(:valid?).and_return(false)
      expect{request_base.perform}.to raise_error{ Copy::AuthenticationError }
    end
    it "performs an https request" do
      allow_any_instance_of(Copy::Request::Base).to receive(:valid?).and_return(true)

      expect(connection).to receive(:set_request_data)
      expect(connection).to receive(:request)
      expect(validator).to receive(:validated_data_for)

      Copy::Request::Base.new(nil).perform
    end
  end

  describe "#valid?" do
    it 'is not valid if no info object given' do
      expect(Copy::Request::Base.new(nil)).to_not be_valid
    end
    it 'is not valid if there is no session in info object' do
      allow(info).to receive(:session).and_return(nil)
      expect(request_base).to_not be_valid
    end
    it 'is not valid if session is invalid' do
      allow(session).to receive(:valid?).and_return(false)
      expect(request_base).to_not be_valid
    end
    it 'id valid othercase' do
      expect(request_base).to be_valid
    end
  end
end

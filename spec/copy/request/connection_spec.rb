require "spec_helper"

describe Copy::Request::Connection do
  let(:consumer_key) { '_your_consumen_key_' }
  let(:consumer_secret) { '_your_consumen_secret_' }
  let(:access_token) do
    {
      token: '_your_user_token_',
      secret: '_your_secret_token_'
    }
  end
  let(:connection) { Copy::Request::Connection.new(info) }
  let(:info) do
    Copy::Request::Info.new(:get, nil, 'user', {}, { session: session })
  end
  let(:client) { Copy::Client.new(session) }
  let(:session) { Copy::Session.new(access_token) }

  before :each do
    Copy.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  describe "#set_request_data" do
    it "creates a request_data object" do
      connection.set_request_data

      expect(connection.request_data).to_not be_nil
    end
  end

  describe "#request" do
    it "performs the actual request" do
      connection.set_request_data
      connection.stub(:set_request_data)

      connection.access_token.should_receive(:send).with(*connection.request_data)

      connection.request
    end
  end

  describe "#request_data" do
    it "correctly formats the form data" do
      info = double(
        http_method: :post,
        url: "/some/path",
        data: params,
        subdomain: Copy::DOMAIN_BASE,
        session: session
      )
      connection = Copy::Request::Connection.new(info)
      connection.set_request_data

      connection.request_data.should eq(
        [ :post,
          "https://api.copy.com/some/path",
          {"email"=>"abc_abc.com",
           "event_types[0]"=>"user.created",
           "event_types[1]"=>"user.failed",
           "event_types[2]"=>"team.created",
           "event_types[3]"=>"documents.available"},
          {"X-Api-Version"=>"1"}
        ]
      )
    end
  end

  def params
    {
      email: "abc_abc.com",
      event_types: ["user.created","user.failed", "team.created", "documents.available"]
    }
  end
end

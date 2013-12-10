require "spec_helper"

describe Copy do
  describe ".request" do
    context "given no api key exists" do
      it "raises an authentication error" do
        expect { Copy.request(:get, nil, "clients", {}) }.to raise_error(Copy::AuthenticationError)
      end
    end

    context "with an invalid api key" do
      let(:consumer_key) { '_your_consumen_key_' }
      let(:consumer_secret) { '_your_consumen_secret_' }
      let(:access_token) do
        {
          token: '_your_user_token_',
          secret: '_your_secret_token_'
        }
      end
      let(:client) { Copy::Client.new(session) }
      let(:session) { Copy::Session.new(access_token) }

      before(:each) do
        Copy.config do |configuration|
          configuration[:consumer_key] = consumer_key
          configuration[:consumer_secret] = consumer_secret
        end
        WebMock.stub_request(:any, /#{Copy::API_BASE}/).to_return(:body => "{}")
      end

      it "attempts to get a url with one param" do
        Copy.request(:get, nil, 'user', { param_name: "param_value" }, { session: session })
        WebMock.should have_requested(:get, "https://#{Copy::DOMAIN_BASE}.#{Copy::API_BASE}/#{Copy::API_BASE_PATH}/user?param_name=param_value")
      end

      it "attempts to get a url with more than one param" do
        Copy.request(:get, nil, "user", { client: "client_id", order: "created_at_desc" }, { session: session })
        WebMock.should have_requested(:get, "https://#{Copy::DOMAIN_BASE}.#{Copy::API_BASE}/#{Copy::API_BASE_PATH}/user?client=client_id&order=created_at_desc")
      end

      it "doesn't add a question mark if no params" do
        Copy.request(:post, nil, "user", {}, { session: session })
        WebMock.should have_requested(:post, "https://#{Copy::DOMAIN_BASE}.#{Copy::API_BASE}/#{Copy::API_BASE_PATH}/user")
      end

      it "uses the param id to construct the url" do
        Copy.request(:post, nil, "user", {id: 'new_id'}, { session: session })
        WebMock.should have_requested(:post, "https://#{Copy::DOMAIN_BASE}.#{Copy::API_BASE}/#{Copy::API_BASE_PATH}/user/new_id")
      end
    end
  end
end

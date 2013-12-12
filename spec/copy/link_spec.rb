require "spec_helper"

describe Copy::Link do
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
  let(:valid_attributes) do
      JSON.parse %{
        {
          "id": "wFIK8aMIDvh2",
          "name": "Such a cool Link",
          "public": false,
          "url": "https://copy.com/wFIK8aMIDvh2",
          "url_short": "https://copy.com/wFIK8aMIDvh2",
          "creator_id": "110660",
          "created_time": 1366825349,
          "object_count": 1,
          "confirmation_required": false,
          "status": "viewed",
          "permissions": "sync",
          "recipients": [
            {
              "contact_type": "user",
              "contact_id": "user-1381231",
              "contact_source": "link-3514165",
              "user_id": "1381231",
              "email": "thomashunter@example.com",
              "first_name": "Thomas",
              "last_name": "Hunter",
              "permissions": "sync",
              "emails": [
                {
                  "primary": true,
                  "confirmed": true,
                  "email": "thomashunter@example.com",
                  "gravatar": "eca957c6552e783627a0ced1035e1888"
                },
                {
                  "primary": false,
                  "confirmed": true,
                  "email": "thomashunter@example.net",
                  "gravatar": "c0e344ddcbabb383f94b1bd3486e55ba"
                }
              ]
            }
          ]
        }
      }
  end
  let (:link) do
    Copy::Link.new(valid_attributes)
  end

  before :each do
    Copy.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  describe "#initialize" do
    it 'initializes all attributes correctly' do
      expect(link.url).to eql('https://copy.com/wFIK8aMIDvh2')
      expect(link.id).to eql('wFIK8aMIDvh2')
      expect(link.name).to eql('Such a cool Link')
      expect(link.public).to be_false
      expect(link.recipients.map {|a| a.id }).to eql(%w{1381231})
    end
  end

  describe ".all" do
    let(:link_all) { Copy::Link.all( session: session ) }
    before :each do
      allow(Copy).to receive(:request).and_return([valid_attributes])
    end
    it "makes a new GET request using the correct API endpoint to receive links" do
      expect(Copy).to receive(:request).with(:get, nil, "links", {}, { session: session })
      link_all
    end
    it 'returns a array of links' do
      expect(link_all.first.class).to eql(Copy::Link)
    end
    it 'returns the correct links' do
      expect(link_all.first.id).to eql('wFIK8aMIDvh2')
    end
  end

  describe ".show" do
    let(:link_show) { Copy::Link.show( id: 'wFIK8aMIDvh2', session: session ) }
    before :each do
      allow(Copy).to receive(:request).and_return(valid_attributes)
    end
    it "makes a new GET request using the correct API endpoint to receive a specific link" do
      expect(Copy).to receive(:request).with(:get, nil, "links/wFIK8aMIDvh2", {}, { session: session })
      link_show
    end
    it 'returns a link with the correct id' do
      expect(link_show.id).to eql('wFIK8aMIDvh2')
    end
  end

  describe ".create" do
    let(:create_attributes) do
      {
        public: true,
        name: "My Cool Shared Files",
        paths: [
          "/path/to/file.txt"
        ]
      }
    end
    let(:valid_create_response) do
      JSON.parse(%{
        {
          "id": "MBrss3roGDk4",
          "name": "My Cool Shared Files",
          "public": true,
          "url": "https://copy.com/MBrss3roGDk4",
          "url_short": "https://copy.com/MBrss3roGDk4",
          "creator_id": "1381231",
          "confirmation_required": false,
          "status": "viewed",
          "permissions": "read",
          "recipients": [
          ]
        }
      })
    end
    let(:link_create) { Copy::Link.create(create_attributes.merge(session: session)) }
    before :each do
      allow(Copy).to receive(:request).and_return(valid_create_response)
    end
    it "makes a new GET request using the correct API endpoint to receive a specific link" do
      expect(Copy).to receive(:request).with(:post, nil, "links", create_attributes, { session: session })
      link_create
    end
    it 'returns a link with the correct name' do
      expect(link_create.name).to eql('My Cool Shared Files')
    end
    it 'returns a link with the correct public' do
      expect(link_create.public).to eql(true)
    end
  end

  describe ".delete" do
    let(:link_delete) { Copy::Link.delete(id: 'wFIK8aMIDvh2', session: session) }
    before :each do
      allow(Copy).to receive(:request).and_return({})
    end
    it "makes a new GET request using the correct API endpoint to receive a specific link" do
      expect(Copy).to receive(:request).with(:delete, nil, "links/wFIK8aMIDvh2", {}, { session: session })
      link_delete
    end
  end

end

require "spec_helper"

describe Copy::File do
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
          "id": "/copy",
          "path": "/",
          "name": "Copy Folder",
          "type": "copy",
          "size": null,
          "date_last_synced": null,
          "stub": false,
          "children": [
            {
              "id": "/copy/Applications",
              "path": "/Applications",
              "name": "Applications",
              "link_name": "",
              "token": "",
              "permissions": "",
              "public": false,
              "type": "dir",
              "size": null,
              "date_last_synced": 1360079517,
              "stub": true,
              "counts": [
              ],
              "recipient_confirmed": false,
              "object_available": true,
              "links": [
                {
                  "id": "hPTBeqqN9Bg9",
                  "public": true,
                  "expires": false,
                  "expired": false,
                  "url": "https://copy.com/hPTBeqqN9Bg9/Applications",
                  "url_short": "https://copy.com/hPTBeqqN9Bg9",
                  "recipients": [
                  ],
                  "creator_id": "1381231",
                  "confirmation_required": false
                }
              ],
              "url": "https://copy.com/web/Applications",
              "thumb": false
            },
            {
              "id": "/copy/binding-of-isaac.png",
              "path": "/binding-of-isaac.png",
              "name": "binding-of-isaac.png",
              "link_name": "",
              "token": "",
              "permissions": "",
              "public": false,
              "type": "file",
              "size": 164850,
              "date_last_synced": 1363573463,
              "stub": true,
              "counts": [
              ],
              "recipient_confirmed": false,
              "object_available": true,
              "links": [
              ],
              "url": "https://copy.com/web/bad-binding-of-isaac.png",
              "revision_id": 2897,
              "thumb": "https://copy.com/thumbs/bad-binding-of-isaac.png",
              "thumb_original_dimensions": {
                "width": 800,
                "height": 620
              }
            }
          ]
        }
      }
  end
  let (:file) do
    Copy::File.new(valid_attributes)
  end

  before :each do
    Copy.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  describe "#initialize" do
    it 'initializes all attributes correctly' do
      expect(file.path).to eql('/')
      expect(file.id).to eql('/copy')
      expect(file.name).to eql('Copy Folder')
      expect(file.type).to eql('copy')
      expect(file.children.map {|a| a.name }).to eql(%w{Applications binding-of-isaac.png})
    end
  end

  describe ".show" do
    let(:file_show) { Copy::File.show( id: '/', session: session ) }
    before :each do
      allow(Copy).to receive(:request).and_return(valid_attributes)
    end
    it "makes a new GET request using the correct API endpoint to receive a specific user" do
      expect(Copy).to receive(:request).with(:get, nil, "meta/", {}, { session: session })
      file_show
    end
    it 'returns a file with the correct path' do
      expect(file_show.path).to eql('/')
    end
    it 'returns a file with the correct id' do
      expect(file_show.id).to eql('/copy')
    end
    it 'returns a file with the correct name' do
      expect(file_show.name).to eql('Copy Folder')
    end
    it 'returns a file with the correct type' do
      expect(file_show.type).to eql('copy')
    end
  end

  describe "#is_dir?" do
    it 'rerurns false if file is a file' do
      allow(file).to receive(:type).and_return('file')

      expect(file.is_dir?).to be_false
    end
    it 'returns true othercase' do
      allow(file).to receive(:type).and_return('root')

      expect(file.is_dir?).to be_true
    end
  end

  describe "#stubbed?" do
    it 'returns stub field value' do
      allow(file).to receive(:stub).and_return(false)

      expect(file.stubbed?).to be_false
    end
  end
end

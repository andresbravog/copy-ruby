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
  let(:valid_activity_attributes) do
    JSON.parse %{
        {
          "id": "/copy/Big%20API%20Changes/API-Changes.md/@activity",
          "path": "/Big API Changes/API-Changes.md",
          "name": "Activity",
          "token": null,
          "permissions": null,
          "syncing": false,
          "public": false,
          "type": "file",
          "size": 12670,
          "date_last_synced": 1365543105,
          "stub": false,
          "recipient_confirmed": false,
          "url": "https://copy.com/web/Big%20API%20Changes/API-Changes.md",
          "revision_id": "5000",
          "thumb": null,
          "share": null,
          "counts": [
          ],
          "links": [
          ],
          "revisions": [
            {
              "revision_id": "5000",
              "modified_time": 1365543105,
              "size": 12670,
              "latest": true,
              "conflict": false,
              "id": "/copy/Big%20API%20Changes/API-Changes.md/@activity/@time:1365543105",
              "type": "revision",
              "creator": {
                "user_id": "1381231",
                "created_time": 1358175510,
                "email": "thomashunter@example.com",
                "first_name": "Thomas",
                "last_name": "Hunter",
                "confirmed": true
              }
            },
            {
              "revision_id": "4900",
              "modified_time": 1365542000,
              "size": 12661,
              "latest": false,
              "conflict": true,
              "id": "/copy/Big%20API%20Changes/API-Changes.md/@activity/@time:1365542000",
              "type": "revision",
              "creator": {
                "user_id": "1381231",
                "created_time": 1358175510,
                "email": "thomashunter@example.com",
                "first_name": "Thomas",
                "last_name": "Hunter",
                "confirmed": true
              }
            },
            {
              "revision_id": "4800",
              "modified_time": 1365543073,
              "size": 12658,
              "latest": false,
              "conflict": false,
              "id": "/copy/Big%20API%20Changes/API-Changes.md/@activity/@time:1365543073",
              "type": "revision",
              "creator": {
                "user_id": "1381231",
                "created_time": 1358175510,
                "email": "thomashunter@example.com",
                "first_name": "Thomas",
                "last_name": "Hunter",
                "confirmed": true
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

  describe ".activity" do
    let(:file_activity) { Copy::File.activity( id: '/copy/readme.txt', session: session ) }
    before :each do
      allow(Copy).to receive(:request).and_return(valid_activity_attributes)
    end
    it "makes a new GET request using the correct API endpoint to receive a specific user" do
      expect(Copy).to receive(:request).with(:get, nil, "meta/copy/readme.txt/@activity", {}, { session: session })
      file_activity
    end
    it 'returns a file with the correct revision_id' do
      expect(file_activity.revision_id).to eql('5000')
    end
    it 'returns a file with the correct revisons data' do
      expect(file_activity.revisions.first.class).to eql(Copy::Revision)
    end
  end

  describe ".delete" do
    let(:file_delete) { Copy::File.delete( id: '/copy/readme.txt', session: session ) }
    before :each do
      allow(Copy).to receive(:request).and_return(true)
    end
    it "makes a new GET request using the correct API endpoint to receive a specific user" do
      expect(Copy).to receive(:request).with(:delete, nil, "files/copy/readme.txt", {}, { session: session })
      file_delete
    end
    it 'returns true' do
      expect(file_delete).to be_true
    end
  end

  describe ".create" do
    let(:file) do
      path = File.expand_path(File.join(File.dirname(__FILE__), "../fixtures/hola.txt"))
      File.open(path)
    end
    let(:file_create) { Copy::File.create( path: 'path', session: session, file: file ) }
    context 'under control' do
      before :each do
        allow(Copy).to receive(:request).and_return(valid_attributes)
      end
      it "makes a new GET request using the correct API endpoint to receive a specific file" do
        expect(Copy).to receive(:request).with(:post, nil, "files/path", { file: file }, { session: session })
        file_create
      end
      it 'returns true' do
        expect(file_create.class).to be(Copy::File)
      end
    end
    it 'test' do
      file_create
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

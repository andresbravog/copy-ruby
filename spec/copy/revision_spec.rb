require "spec_helper"

describe Copy::Revision do

  let(:valid_attributes) do
      JSON.parse %{
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
        }
      }
  end

  let (:revision) do
    Copy::Revision.new(valid_attributes)
  end

  describe "#initialize" do
    it 'initializes all attributes correctly' do
      expect(revision.revision_id).to eql('5000')
      expect(revision.id).to eql('/copy/Big%20API%20Changes/API-Changes.md/@activity/@time:1365543105')
      expect(revision.size).to eql(12670)
      expect(revision.latest).to eql(true)
      expect(revision.creator.class).to eql(Copy::User)
      expect(revision.creator.id).to eql('1381231')
      expect(revision.creator.email).to eql('thomashunter@example.com')
    end
  end
end

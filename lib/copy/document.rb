module Copy
  class Document < Base
    include Copy::Operations::Show
    include Copy::Operations::All

    attr_accessor :id, :user_id, :document_name, :page_count, :created,
    :updated, :original_filename, :thumbnail, :signatures, :seals, :texts,
    :inserts, :tags, :fields, :requests, :notary_invites, :version_time, :pages

    # Parses UNIX timestamps and creates Time objects.
    def parse_timestamps
      super
      @updated = updated.to_i if updated.is_a? String
      @updated = Time.at(updated) if updated
    end

    class << self
      # Redefining the documents api endpoint
      #
      def api_all_url
          "user/documentsv2"
      end
      protected :api_all_url
    end

  end
end

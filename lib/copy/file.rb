
module Copy
  class File < Base
    include Copy::Operations::Show
    include Copy::Operations::Delete
    include Copy::Operations::Activity

    TYPES = [ :file, :dir, :root, :copy, :inbox ]

    attr_accessor :id, :path, :name, :type, :stub,
      :children_count, :size, :recipient_confirmed, :mime_type, :link_name, :token,
      :creator_id, :permissions, :syncing, :public, :object_available, :url,
      :thumb, :share, :children, :children_count, :revision_id,
      :modified_time, :date_last_synced,
      :children, :counts, :inbox_notifications, :links, :revisions

    def initialize(attributes = {})
      super(attributes)
      parse_children
      parse_revisions
    end

    def is_dir?
      type != 'file'
    end

    def stubbed?
      stub
    end

    def parse_children
      return unless children
      results = []
      children.each do |obj|
        results << self.class.new(obj)
      end
      @children = results
    end
    protected :parse_children

    def parse_revisions
      return unless revisions
      results = []
      revisions.each do |obj|
        results << Copy::Revision.new(obj)
      end
      @revisions = results
    end
    protected :parse_revisions

    class << self
      # Redefining the documents api endpoint
      #
      def api_member_url(id=nil)
          "meta"
          url = "meta"
          url += "#{id}" if id
          url
      end
      protected :api_member_url
    end

  end
end

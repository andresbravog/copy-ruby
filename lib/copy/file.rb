
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
      parse_links
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

    def parse_links
      return unless links
      results = []
      links.each do |obj|
        results << Copy::Link.new(obj)
      end
      @links = results
    end
    protected :parse_revisions

    class << self
      protected

      # Redefining the files api endpoint
      #
      def api_member_url(id=nil, method=nil)
        url = api_resource_name(method)
        url += "#{id}" if id
        url
      end

      # Redefining the files api resource name
      # depending on the interaction
      #
      def api_resource_name(method=nil)
        case method
        when :show, :activity
          'meta'
        else
          super(method)
        end
      end
    end

  end
end

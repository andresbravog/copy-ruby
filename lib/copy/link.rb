module Copy
  class Link < Base
    include Copy::Operations::All
    include Copy::Operations::Show
    include Copy::Operations::Delete
    include Copy::Operations::Create
    include Copy::Operations::Meta

    attr_accessor :id, :name, :public, :url, :url_short, :creator_id,
      :created_time, :object_count, :confirmation_required, :status,
      :permissions, :recipients

    # Metadata fields
    attr_accessor :children, :path, :token, :creator_id, :permissions,
      :syncing, :public, :type, :size, :stub, :date_last_synced, :counts,
      :children_count, :share

    def initialize(attributes = {})
      super(attributes)
      parse_recipients
      parse_children
    end

    protected

    def parse_recipients
      return if @recipients.nil?
      results = []
      @recipients.each do |object|
        case object['contact_type']
        when 'user'
          results << Copy::User.new(object)
        end
      end
      @recipients = results
    end

    def parse_children
      return if @children.nil?
      results = []
      @children.each do |object|
        results << Copy::File.new(object)
      end
      @children = results
    end
  end
end

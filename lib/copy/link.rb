module Copy
  class Link < Base
    include Copy::Operations::All
    include Copy::Operations::Show
    include Copy::Operations::Delete
    include Copy::Operations::Create

    attr_accessor :id, :name, :public, :url, :url_short, :creator_id,
      :created_time, :object_count, :confirmation_required, :status,
      :permissions, :recipients

    def initialize(attributes = {})
      super(attributes)
      parse_recipients
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
  end
end

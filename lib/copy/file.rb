
module Copy
  class File < Base
    include Copy::Operations::Show

    TYPES = [ :file, :dir, :root, :copy, :inbox ]

    attr_accessor :id, :path, :name, :type, :stub, :children

    def initialize(attributes = {})
      super(attributes)
      parse_children
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

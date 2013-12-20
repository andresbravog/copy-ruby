
module Copy
  class File < Base
    include Copy::Operations::Show
    include Copy::Operations::Delete
    include Copy::Operations::Activity
    include Copy::Operations::Create

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
      # Create operation overwrite to parse file first
      def create(attrs)
        super(parse_file(attrs))
      end

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

      # Parses the uploaded file to make the correct api request
      #
      # @param attributes [Hash] attributes to parse
      # @return [Hash] parsed attributes hash
      def parse_file(attrs)
        return attrs unless attrs[:file]
        attrs[:file_attrs] = {}
        if attrs[:file].kind_of?(::File) or attrs[:file].kind_of?(::Tempfile) then
          attrs[:file_attrs][:name] = attrs[:file].respond_to?(:original_filename) ? attrs[:file].original_filename : ::File.basename(attrs[:file].path)
          attrs[:file_attrs][:local_path] = attrs[:file].path
        elsif attrs[:file].kind_of?(String) then
          attrs[:file_attrs][:local_path] = attrs[:file]
          attrs[:file] = ::File.new(attrs[:file])
          attrs[:file_attrs][:name] = ::File.basename(attrs[:file_attrs][:local_path])
        elsif attrs[:file].kind_of?(StringIO) then
          raise(ArgumentError, "Must specify the :as option when uploading from StringIO") unless attrs[:as]
          attrs[:file_attrs][:local_path] = attrs[:as]

          # hack for bug in UploadIO
          class << file
            attr_accessor :path
          end
          file.path = attrs[:file]
        else
          raise ArgumentError, "local_file must be a File, StringIO, or file path"
        end

        attrs[:file_attrs][:name] = ::File.basename(attrs.delete(:as)) if attrs[:as]

        attrs
      end

      # Yiha! Api REST
      #
      def api_collection_url(attrs={})
        path = attrs.delete(:path)
        url = super(attrs)
        url += '/' + path if path
        url
      end
    end

  end
end

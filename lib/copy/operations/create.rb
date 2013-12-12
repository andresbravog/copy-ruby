module Copy
  module Operations
    module Create
      module ClassMethods
        # Creates a new object
        #
        # @param [Hash] attributes The attributes of the created object
        def create(attributes)
          session = attributes.delete(:session)
          response = Copy.request(:post, nil, api_collection_url, attributes, options_for_request(session: session))
          self.new(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

module Copy
  module Operations
    module Create
      module ClassMethods
        # Creates a new object
        #
        # @param [Hash] attributes The attributes of the created object
        def create(attributes)
          response = Copy.request(:post, nil, api_create_url, attributes, options_for_request)
          self.new(response)
        end

        # URl for the create endpoint
        # overwrite this in the model if the api is not well named
        #
        def api_create_url
          "#{self.name.split("::").last.downcase}"
        end
        protected :api_create_url
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

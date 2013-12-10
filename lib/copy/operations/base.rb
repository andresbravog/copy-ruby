module Copy
  module Operations
    module Base
      module ClassMethods
        # Options for request
        # overwrite this in the model to set security
        #
        # @return [Hash]
        def options_for_request(attributes)
          raise AuthenticationError unless attributes[:session]
          {
            session: attributes[:session]
          }
        end

        # URl for the member endpoints
        # overwrite this in the model if the api is not well named
        #
        def api_member_url(id=nil)
          url = "#{self.name.split("::").last.downcase}"
          url += "/#{id}" if id
          url
        end
        protected :api_member_url

        # URl for the collection endpoints
        # overwrite this in the model if the api is not well named
        #
        def api_collection_url
          "#{self.name.split("::").last.downcase}"
        end
        protected :api_collection_url
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

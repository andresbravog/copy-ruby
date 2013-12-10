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
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

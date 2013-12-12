module Copy
  module Operations
    module Activity
      module ClassMethods
        # Retrieves all available objects from the Copy API
        #
        # @param [Hash] options Options to pass to the API
        # @return [Array] The available objects
        def activity(attributes={})
          response = Copy.request(
            :get,
            nil,
            api_member_url(attributes[:id], :activity ) + '/@activity',
            {},
            options_for_request(attributes)
          )
          self.new(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end

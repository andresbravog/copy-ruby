module Copy
  module Operations
    module All
      module ClassMethods
        # Retrieves all available objects from the Copy API
        #
        # @param [Hash] options Options to pass to the API
        # @return [Array] The available objects
        def all(attributes = {})
          response = Copy.request(:get, nil, api_all_url , attributes, options_for_all(attributes))
          results_from response
        end

        # URl for the all endpoint
        # overwrite this in the model if the api is not well named
        #
        def api_all_url
          "#{self.name.split("::").last.downcase}"
        end
        protected :api_all_url

        # Options for all
        # overwrite this in the model to set security
        #
        # @return [Hash]
        def options_for_all(attributes)
          access_token = attributes.delete(:access_token)
          raise AuthenticationError unless access_token
          {
            auth_type: :user_token,
            auth_token: access_token
          }
        end

        private
        def results_from(response)
          results = []
          response.each do |obj|
            results << self.new(obj)
          end
          results
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end

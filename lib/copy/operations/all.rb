module Copy
  module Operations
    module All
      module ClassMethods
        # Retrieves all available objects from the Copy API
        #
        # @param [Hash] options Options to pass to the API
        # @return [Array] The available objects
        def all(attributes = {})
          response = Copy.request(:get, nil, api_collection_url , attributes, options_for_request(attributes))
          results_from response
        end

        def results_from(response)
          results = []
          response.each do |obj|
            results << self.new(obj)
          end
          results
        end
        private :results_from
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end

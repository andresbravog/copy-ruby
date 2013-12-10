module Copy
  module Operations
    module Find
      module ClassMethods
        # Finds a given object
        #
        # @param [Integer] id The id of the object that should be found
        # @return [Copy::Base] The found object
        def find(attibutes)
          id = attibutes.delete(:id)
          response = Copy.request(:get, nil, api_find_url(id), {}, options_for_request(attributes))
          self.new(response["data"])
        end

        # URl for the find endpoint
        # overwrite this in the model if the api is not well named
        #
        def api_find_url(id)
          "#{self.name.split("::").last.downcase}s/#{id}"
        end
        protected :api_find_url
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

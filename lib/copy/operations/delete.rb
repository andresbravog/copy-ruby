module Copy
  module Operations
    module Delete
      module ClassMethods
        # Deletes the given object
        #
        # @param [Integer] id The id of the object that gets deleted
        def delete(attributes={})
          id = attributes.delete(:id)
          response = Copy.request(:delete, nil, api_delete_url(id) , {}, options_for_request(attributes))
          true
        end

        # URl for the delete endpoint
        # overwrite this in the model if the api is not well named
        #
        def api_delete_url(id)
          "#{self.name.split("::").last.downcase}s/#{id}"
        end
        protected :api_delete_url
     end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

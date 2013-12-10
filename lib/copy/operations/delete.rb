module Copy
  module Operations
    module Delete
      module ClassMethods
        # Deletes the given object
        #
        # @param [Integer] id The id of the object that gets deleted
        def delete(attributes={})
          id = attributes.delete(:id)
          response = Copy.request(:delete, nil, api_delete_url(id) , {}, options_for_delete(attributes))
          true
        end

        # URl for the delete endpoint
        # overwrite this in the model if the api is not well named
        #
        def api_delete_url(id)
          "#{self.name.split("::").last.downcase}s/#{id}"
        end
        protected :api_delete_url

        # Options for delete
        # overwrite this in the model to set security
        #
        # @return [Hash]
        def options_for_delete(attributes)
          access_token = attributes.delete(:access_token)
          raise AuthenticationError unless access_token
          {
            auth_type: :user_token,
            auth_token: access_token
          }
        end
        protected :options_for_delete
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

module Copy
  module Operations
    module Update

      module ClassMethods
        # Updates a object
        # @param [Integer] id The id of the object that should be updated
        # @param [Hash] attributes The attributes that should be updated
        def update_attributes(attributes={})
          id = attributes.delete(:id)
          response = Copy.request(:put, nil, api_update_url(id), attributes, options_for_update(attributes))
          self.new(response["data"])
        end

        # URl for the update endpoint
        # overwrite this in the model if the api is not well named
        #
        def api_update_url(id=nil)
          url = "#{self.name.split("::").last.downcase}"
          url += "/#{id}" if id
          url
        end
        protected :api_update_url

        # Options for update
        # overwrite this in the model to set security
        #
        # @return [Hash]
        def options_for_update(attributes)
          access_token = attributes.delete(:access_token)
          raise AuthenticationError unless access_token
          {
            auth_type: :user_token,
            auth_token: access_token
          }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      # Updates a object
      #
      # @param [Hash] attributes The attributes that should be updated
      def update_attributes(attributes)
        response = Copy.request(:put, nil, "#{self.class.name.split("::").last.downcase}/#{id}", attributes)
        set_attributes(response["data"])
      end
    end
  end
end

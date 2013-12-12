module Copy
  module Operations
    module Update
      module ClassMethods
        # Updates a object
        # @param [Integer] id The id of the object that should be updated
        # @param [Hash] attributes The attributes that should be updated
        def update(attributes={})
          id = attributes.delete(:id)
          session = attributes.delete(:session)
          response = Copy.request(:put, nil, api_member_url(id, :updated), attributes, options_for_request(session: session))
          self.new(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

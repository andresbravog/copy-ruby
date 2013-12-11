module Copy
  module Operations
    module Delete
      module ClassMethods
        # Deletes the given object
        #
        # @param [Integer] id The id of the object that gets deleted
        def delete(attributes={})
          id = attributes.delete(:id)
          response = Copy.request(:delete, nil, api_member_url(id) , {}, options_for_request(attributes))
          true
        end
     end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

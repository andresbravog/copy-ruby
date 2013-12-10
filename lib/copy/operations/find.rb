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
          response = Copy.request(:get, nil, api_member_url({id: id}), {}, options_for_request(attributes))
          self.new(response["data"])
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

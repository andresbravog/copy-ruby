module Copy
  module Operations
    module Show
      module ClassMethods
        # Shows a given object
        #
        # @param [Integer] id The id of the object that should be shown
        # @return [Copy::Base] The found object
        def show(attributes={})
          response = Copy.request(:get, nil, api_member_url(attributes[:id]), {}, options_for_request(attributes))
          self.new(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

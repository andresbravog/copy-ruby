module Copy
  module Operations
    module Show
      module ClassMethods
        # Shows a given object
        #
        # @param [Integer] id The id of the object that should be shown
        # @return [Copy::Base] The found object
        def show(attributes={})
          response = Copy.request(:get, nil, api_show_url(attributes[:id]), {}, options_for_request(attributes))
          self.new(response)
        end

        # URl for the show endpoint
        # overwrite this in the model if the api is not well named
        #
        def api_show_url(id=nil)
          url = "#{self.name.split("::").last.downcase}"
          url += "/#{id}" if id
          url
        end
        protected :api_show_url
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

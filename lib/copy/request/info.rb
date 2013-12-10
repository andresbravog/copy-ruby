module Copy
  module Request
    class Info
      attr_accessor :http_method, :api_url, :data, :subdomain, :session, :base_path

      def initialize(http_method, subdomain, api_url, data, options={})
        @http_method = http_method
        @subdomain   = subdomain || DOMAIN_BASE
        @api_url     = api_url
        @data        = data
        @base_path   = API_BASE_PATH
        @session     = options[:session]
      end

      def url
        url = "/#{base_path}/#{api_url}"
        if has_id?
          url += "/#{data[:id]}"
          data.delete(:id)
        end

        url
      end

      def path_with_params(path, params)
        unless params.empty?
          encoded_params = URI.encode_www_form(params)
          [path, encoded_params].join("?")
        else
          path
        end
      end

      protected

      def has_id?
        data[:id].nil?
      end
    end
  end
end

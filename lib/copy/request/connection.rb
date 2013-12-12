module Copy
  module Request
    class Connection
      include Helpers
      attr_reader :access_token, :request_data

      def initialize(request_info)
        @info = request_info
        @session = @info.session if @info
        @access_token = @info.session.access_token if @session
      end

      def request
        return unless access_token
        access_token.send(*request_data)
      end

      def set_request_data
        @request_data = []
        @request_data << @info.http_method if @info
        @request_data << api_url
        unless use_url_params?
          @request_data << body_json
        end
        @request_data << headers
      end

      protected

      # Body params hash
      #
      # @return [Hash]
      def body_hash
        return {} unless @info
        @info.data
      end

      # Json encoded body
      #
      # @return [String]
      def body_json
        return '' unless body_hash
        JSON.generate(body_hash)
      end

      # Body params url encoded
      #
      # @return [String]
      def encoded_www_body
        return '' unless body_hash
        URI.encode_www_form(body_hash)
      end

      def use_url_params?
        return false unless @info
        case @info.http_method
        when :post, :put
          false
        else
          true
        end
      end

      def headers
        { "X-Api-Version" => API_VERSION }
      end

      # Returns the api url foir this request or default
      def api_url
        url = 'https://' + domain + '.' + API_BASE
        if @info
          url += @info.url
          if use_url_params? && !body_hash.empty?
            url += '?' + encoded_www_body
          end
        end
        url
      end

      # Returns the domain for the current request or the default one
      def domain
        return @info.subdomain if @info
        DOMAIN_BASE
      end
    end
  end
end

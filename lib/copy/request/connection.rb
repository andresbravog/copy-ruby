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
        if @info && [:post, :put].include?(@info.http_method)
          @request_data << body
        end
        @request_data << headers
      end

      protected

      def body
        normalize_params(@info.data)
      end

      def headers
        { "X-Api-Version" => API_VERSION }
      end

      # Returns the api url foir this request or default
      def api_url
        url = 'https://' + domain + '.' + API_BASE
        url += @info.url if @info
      end

      # Returns the domain for the current request or the default one
      def domain
        return @info.subdomain if @info
        DOMAIN_BASE
      end
    end
  end
end

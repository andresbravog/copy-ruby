require "net/http"
require "net/https"
require "json"
require "copy/version"

module Copy
  DOMAIN_BASE = 'api'
  API_BASE    = 'copy.com'
  API_BASE_PATH = 'rest'
  API_VERSION = '1'
  ROOT_PATH   = File.dirname(__FILE__)

  @@configuration = {}

  autoload :Base,           "copy/base"
  autoload :User,           "copy/user"
  autoload :Client,         "copy/client"
  autoload :Session,        "copy/session"

  module Operations
    autoload :All,    "copy/operations/all"
    autoload :Create, "copy/operations/create"
    autoload :Delete, "copy/operations/delete"
    autoload :Find,   "copy/operations/find"
    autoload :Show,   "copy/operations/show"
    autoload :Update, "copy/operations/update"
  end

  module Request
    autoload :Base,       "copy/request/base"
    autoload :Connection, "copy/request/connection"
    autoload :Helpers,    "copy/request/helpers"
    autoload :Info,       "copy/request/info"
    autoload :Validator,  "copy/request/validator"
  end

  class CopyError < StandardError; end
  class AuthenticationError < CopyError; end
  class APIError            < CopyError; end

  # Gives configuration abilities
  # to setup api_key and api_secret
  #
  # @example
  #   Copy.config do |configuration|
  #     configuration[:api_key] = '_your_api_key'
  #     configuration[:api_secret] = '_your_api_secret'
  #   end
  #
  # @return [String] The api key
  def self.config(&block)
    yield(@@configuration)
    @@configuration
  end

  def self.configuration
    @@configuration
  end

  def self.configuration=(value)
    @@configuration = value
  end

  # Makes a request against the Copy API
  #
  # @param [Symbol] http_method The http method to use, must be one of :get, :post, :put and :delete
  # @param [String] domain The API domain to use
  # @param [String] api_url The API url to use
  # @param [Hash] data The data to send, e.g. used when creating new objects.
  # @return [Array] The parsed JSON response.
  def self.request(http_method, domain, api_url, data, options={})
    info = Request::Info.new(http_method, domain, api_url, data, options)
    Request::Base.new(info).perform
  end
end

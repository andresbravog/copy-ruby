$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require "copy"
require "rspec"
require "rspec/autorun"
require "webmock/rspec"
require "pry"
require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
end

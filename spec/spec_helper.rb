RUBY_1_9 = (RUBY_VERSION =~ /^1\.9/)
if RUBY_1_9 && !ENV['CI']
  require 'simplecov'
  SimpleCov.add_filter 'gems'
  SimpleCov.start
end

RSpec.configure do |rspec|
  rspec.mock_with :rspec do |mocks|
    mocks.yield_receiver_to_any_instance_implementation_blocks = true
  end
end

require "diff_matcher"

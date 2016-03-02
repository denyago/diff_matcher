require 'rspec/core'
require 'diff_matcher/rspec/dsl'
require 'diff_matcher/rspec/be_matching'
require 'diff_matcher/rspec/be_json_matching'
require 'diff_matcher/rspec/util'

RSpec.configure { |c| c.include DiffMatcher::RSpec::Dsl }

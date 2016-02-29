module DiffMatcher
  module RSpec
    module Dsl
      def be_matching(expected)
        BeMatching.new(expected)
      end

      def be_json_matching(expected)
        BeJsonMatching.new(expected)
      end
    end
  end
end

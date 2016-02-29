module DiffMatcher
  module RSpec
    module Util
      class Normalizer
        def initialize(source_data)
          @source_data = source_data
        end

        def normalized
          return safe_deep_symbolize(source_data) unless source_data.is_a?(Array)
          source_data.map { |d| safe_deep_symbolize(d) }
        end

        private

        attr_reader :source_data

        def safe_deep_symbolize(obj)
          return obj unless obj.respond_to?(:deep_symbolize_keys)

          obj.deep_symbolize_keys
        end
      end

      class Orderer
        def initialize(source_data)
          @source_data = source_data
        end

        def order(pattern)
          return source_data unless source_data.is_a?(Array)
          order_by(pattern)
        end

        private

        attr_reader :source_data

        def order_by(pattern)
          source_data.sort_by do |member|
            p =  pattern.is_a?(Regexp) ? pattern : %r{\A#{pattern}\z}
            member[member.keys.detect { |k| k =~ p }]
          end
        end
      end
    end
  end
end

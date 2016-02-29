module DiffMatcher
  module RSpec
    class BeMatching
      attr_reader :expected, :actual, :options

      DEFAULT_OPTIONS = {
        :color_enabled => ::RSpec::configuration.color_enabled?,
        :quiet         => true
      }.freeze

      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @actual     = actual
        @difference = diff_matcher_for(actual)

        @difference.matching?
      end

      def with_options(options)
        @options = options
        self
      end

      def normalized
        @normalized = true
        self
      end

      def ordered(pattern = :id)
        @order_pattern = pattern
        self
      end

      def failure_message
        error_message
      end

      def failure_message_when_negated
        error_message
      end

      def description
        "match via DiffMatcher #{expected}" + (options.blank? ? '' : " with options: #{options}")
      end

      private

      attr_reader :difference, :order_pattern

      def error_message
        "diff is:\n" + difference.to_s
      end

      def diff_matcher_for(actual)
        normalized_actual   = normalize? ? Util::Normalizer.new(actual).normalized   : actual
        normailzed_expected = normalize? ? Util::Normalizer.new(expected).normalized : expected
        unless order_pattern.nil?
          normalized_actual   = Util::Orderer.new(normalized_actual).order(order_pattern)
          normailzed_expected = Util::Orderer.new(normailzed_expected).order(order_pattern)
        end
        DiffMatcher::Difference.new(normailzed_expected, normalized_actual, (options || DEFAULT_OPTIONS.dup))
      end

      def normalize?
        !!@normalized
      end
    end
  end
end

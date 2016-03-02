module DiffMatcher
  module RSpec
    class BeJsonMatching < BeMatching
      def matches?(actual)
        parsed = parse(actual)
        return false if error_parsing?

        super(parsed)
      end

      private

      attr_reader :json_parsing_error

      def parse(string)
        JSON.parse(string)
      rescue => e
        @json_parsing_error = e.to_s
        {}
      end

      def error_parsing?
        !json_parsing_error.nil?
      end

      def error_message
        if error_parsing?
          "error parsing JSON: #{json_parsing_error}"
        else
          super
        end
      end
    end
  end
end

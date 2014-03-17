require "quack/type"

module Quack
  module Types
    class Time < Quack::Type
      ISO_8601 = /
        (?<year>\d{4})-
        (?<month>\d{2})-
        (?<day>\d{2})T
        (?<hour>\d{2}):
        (?<minute>\d{2}):
        (?<second>\d{2})
        (?<offset>Z|(\+|-)(\d{2}):(\d{2}))
      /x

      UTC = "+00:00"

      class << self
        def built_in_types
          [::Time]
        end

        def already_coerced?(value)
          built_in_types.include?(value.class)
        end

        def matches?(value)
          already_coerced?(value) || !!(value.to_s =~ ISO_8601)
        end
      end

      def parse_offset(offset)
        offset == "Z" ? UTC : offset
      end

      def already_coerced?
        self.class.already_coerced?(value)
      end

      def to_coerced
        return value if already_coerced?
        parts = value.to_s.scan(ISO_8601).flatten
        offset = parse_offset(parts.pop)
        parts = parts.map(&:to_i) << offset
        ::Time.new(*parts)
      rescue => ex
        raise ParseError.new(ex.message)
      end

      def to_s
        to_coerced.iso8061
      end
    end
  end
end
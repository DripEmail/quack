require "quack/type"

module Quack
  module Types
    class Boolean < Quack::Type
      class << self
        def matches?(value)
          value.to_s == "true" || value.to_s == "false"
        end
      end

      def to_coerced
        value.to_s == "true"
      end
    end
  end
end
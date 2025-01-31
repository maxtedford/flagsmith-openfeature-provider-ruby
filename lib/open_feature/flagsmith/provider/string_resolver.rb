# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"
require "open_feature/flagsmith/provider/resolver"

module OpenFeature
  module Flagsmith
    class Provider
      # @api private
      class StringResolver < Resolver
        def resolve(flag_key:, default_value:, evaluation_context:)
          unless default_value.nil? || default_value.is_a?(String)
            raise TypeMismatchError, "Default value must be a string or nil"
          end

          super
        end

        def process_value(value)
          # Note that we do not try to call `#to_s` on the value, because
          # every value in Ruby responds to `#to_s`, so it would be too easy
          # to accidentally end up with an unexpected value.
          raise TypeMismatchError, "Flag value is not a string" unless value.is_a?(String)

          value
        end
      end
    end
  end
end

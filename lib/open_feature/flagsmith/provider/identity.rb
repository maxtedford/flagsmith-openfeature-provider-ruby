# frozen_string_literal: true

require "open_feature/flagsmith/provider/error"

module OpenFeature
  module Flagsmith
    class Provider
      # Represents a Flagsmith identity.
      #
      # @api private
      class Identity
        # Key used in {OpenFeature::SDK::EvaluationContext} to mark whether the
        # identity in the evaluation context is transient.
        #
        # @see https://github.com/Flagsmith/flagsmith/issues/4278
        TRANSIENT_IDENTITY_KEY = "transient_identity"

        # Creates a new {Identity} from the given evaluation context
        #
        # @param evaluation_context [OpenFeature::SDK::EvaluationContext]
        # @return [Identity]
        def self.from_context(evaluation_context)
          traits = evaluation_context.fields.dup

          identifier = traits.delete(SDK::EvaluationContext::TARGETING_KEY) do
            raise TargetingKeyMissingError, "Missing identity targeting key in evaluation context"
          end

          transient = traits.delete(TRANSIENT_IDENTITY_KEY)

          new(identifier:, transient:, traits:)
        end

        # The ID of the identity
        # @see https://docs.flagsmith.com/basic-features/managing-identities
        #
        # @return [String]
        attr_reader :identifier

        # Whether this identity is transient or not
        # @see https://github.com/Flagsmith/flagsmith/issues/4278
        #
        # @return [Boolean]
        attr_reader :transient

        # Additional identity traits
        # @see https://docs.flagsmith.com/basic-features/managing-identities#identity-traits
        #
        # @return [Hash(String, Any)]
        attr_reader :traits

        def initialize(identifier:, transient:, traits:)
          @identifier = identifier
          @transient = transient
          @traits = traits
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsApplicationRecord < Base
        MSG = "Models should subclass from ApplicationRecord"

        # @!method active_record_base_const?(node)
        def_node_matcher :active_record_base_const?, <<-PATTERN
          (const (const nil? :ActiveRecord) :Base)
        PATTERN

        # @!method application_record_const?(node)
        def_node_matcher :application_record_const?, <<-PATTERN
          (const nil? :ApplicationRecord)
        PATTERN

        def on_class(node)
          if active_record_base_const?(node.parent_class) && !(application_record_const?(node.identifier))
            add_offense(node.parent_class)
          end
        end
      end
    end
  end
end

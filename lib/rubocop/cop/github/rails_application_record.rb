# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsApplicationRecord < Cop
        MSG = "Models should subclass from ApplicationRecord"

        def_node_matcher :active_record_base_const?, <<-PATTERN
          (const (const nil? :ActiveRecord) :Base)
        PATTERN

        def_node_matcher :application_record_const?, <<-PATTERN
          (const nil? :ApplicationRecord)
        PATTERN

        def on_class(node)
          klass, superclass, _ = *node

          if active_record_base_const?(superclass) && !(application_record_const?(klass))
            add_offense(superclass, location: :expression)
          end
        end
      end
    end
  end
end

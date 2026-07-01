# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      # Inform people when they reach for Class#subclasses (Ruby) or
      # Class#descendants (ActiveSupport).
      #
      # two reasons these can be unreliable:
      #   1. autoload hasn't run yet, so half the tree is invisible
      #   2. GC may have eaten dynamically-defined classes (i.e. in test suites)
      #
      # If you really need it, add a rubocop:disable on the line with a note
      # explaining why future-you won't be sad.
      class UnreliableSubclasses < Base
        MSG = "Avoid `%<method>s` here. It may miss not-yet-autoloaded classes and depends on GC timing. " \
              "Prefer an explicit registry or eager loading."

        RESTRICT_ON_SEND = %i[descendants subclasses].freeze

        # matches Foo.descendants, Foo::Bar.subclasses, self.descendants
        # receiver has to be a constant or `self`
        def_node_matcher :unreliable_call?, <<~PATTERN
          (send {const self} {:descendants :subclasses})
        PATTERN

        # the same thing but with safe navigation operator
        def_node_matcher :unreliable_csend?, <<~PATTERN
          (csend {const self} {:descendants :subclasses})
        PATTERN

        def on_send(node)
          return unless unreliable_call?(node)

          add_offense(node, message: format(MSG, method: node.method_name))
        end

        def on_csend(node)
          return unless unreliable_csend?(node)

          add_offense(node, message: format(MSG, method: node.method_name))
        end
      end
    end
  end
end

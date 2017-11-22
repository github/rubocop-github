# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsRenderInline < Cop
        MSG = "Avoid `render inline:`"

        def_node_matcher :render_with_options?, <<-PATTERN
          (send nil? :render (hash $...))
        PATTERN

        def_node_matcher :inline_key?, <<-PATTERN
          (pair (sym :inline) $_)
        PATTERN

        def on_send(node)
          if option_pairs = render_with_options?(node)
            if option_pairs.detect { |pair| inline_key?(pair) }
              add_offense(node, location: :expression)
            end
          end
        end
      end
    end
  end
end

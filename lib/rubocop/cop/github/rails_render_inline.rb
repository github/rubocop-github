# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsRenderInline < Base
        MSG = "Avoid `render inline:`"

        def_node_matcher :render_with_options?, <<-PATTERN
          (send nil? {:render :render_to_string} (hash $...))
        PATTERN

        def_node_matcher :inline_key?, <<-PATTERN
          (pair (sym :inline) $_)
        PATTERN

        def on_send(node)
          if option_pairs = render_with_options?(node)
            if option_pairs.detect { |pair| inline_key?(pair) }
              add_offense(node)
            end
          end
        end
      end
    end
  end
end

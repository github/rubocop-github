# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsRenderLiteral < Cop
        MSG = "render must be used with a string literal"

        def_node_matcher :literal?, <<-PATTERN
          ({str sym} $_)
        PATTERN

        def_node_matcher :render?, <<-PATTERN
          (send nil :render $...)
        PATTERN

        def_node_matcher :render_literal?, <<-PATTERN
          (send nil :render ({str sym} $_) $...)
        PATTERN

        def_node_matcher :render_with_options?, <<-PATTERN
          (send nil :render (hash $...))
        PATTERN

        def_node_matcher :ignore_key?, <<-PATTERN
          (pair (sym {
            :body
            :file
            :file
            :html
            :json
            :plain
            :xml
          }) $_)
        PATTERN

        def_node_matcher :template_key?, <<-PATTERN
          (pair (sym {
            :action
            :partial
            :template
          }) $_)
        PATTERN

        def_node_matcher :layout_key?, <<-PATTERN
          (pair (sym :layout) $_)
        PATTERN

        def_node_matcher :inline_key?, <<-PATTERN
          (pair (sym :inline) $_)
        PATTERN

        def on_send(node)
          return unless render?(node)

          if render_literal?(node)
          elsif option_pairs = render_with_options?(node)
            if option_pairs.any? { |pair| ignore_key?(pair) }
              return
            end

            if template_node = option_pairs.map { |pair| template_key?(pair) }.compact.first
              if !literal?(template_node)
                add_offense(node, :expression)
              end
            end

            if layout_node = option_pairs.map { |pair| layout_key?(pair) }.compact.first
              if template_node.nil?
                add_offense(node, :expression)
              elsif !literal?(layout_node)
                add_offense(node, :expression)
              end
            end
          else
            add_offense(node, :expression)
          end
        end
      end
    end
  end
end

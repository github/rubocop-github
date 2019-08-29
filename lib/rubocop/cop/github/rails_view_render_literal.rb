# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsViewRenderLiteral < Cop
        MSG = "render must be used with a string literal or an instance of a Class"

        def_node_matcher :literal?, <<-PATTERN
          ({str sym true false nil?} ...)
        PATTERN

        def_node_matcher :render?, <<-PATTERN
          (send nil? :render $...)
        PATTERN

        def_node_matcher :render_literal?, <<-PATTERN
          (send nil? :render ({str sym} $_) $...)
        PATTERN

        def_node_matcher :render_inst?, <<-PATTERN
          (send nil? :render (send _ :new ...) ...)
        PATTERN

        def_node_matcher :render_const?, <<-PATTERN
          (send nil? :render (const _ _) ...)
        PATTERN

        def_node_matcher :render_with_options?, <<-PATTERN
          (send nil? :render (hash $...) ...)
        PATTERN

        def_node_matcher :ignore_key?, <<-PATTERN
          (pair (sym {
            :inline
          }) $_)
        PATTERN

        def_node_matcher :partial_key?, <<-PATTERN
          (pair (sym {
            :file
            :template
            :layout
            :partial
          }) $_)
        PATTERN

        def on_send(node)
          return unless render?(node)

          if render_literal?(node) || render_inst?(node) || render_const?(node)
          elsif option_pairs = render_with_options?(node)
            if option_pairs.any? { |pair| ignore_key?(pair) }
              return
            end

            if partial_node = option_pairs.map { |pair| partial_key?(pair) }.compact.first
              if !literal?(partial_node)
                add_offense(node, location: :expression)
              end
            else
              add_offense(node, location: :expression)
            end
          else
            add_offense(node, location: :expression)
          end
        end
      end
    end
  end
end

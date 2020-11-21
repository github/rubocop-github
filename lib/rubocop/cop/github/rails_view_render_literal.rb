# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsViewRenderLiteral < Cop
        MSG = "render must be used with a literal template and use literals for locals keys"

        def_node_matcher :literal?, <<-PATTERN
          ({str sym true false nil?} ...)
        PATTERN

        def_node_matcher :render?, <<-PATTERN
          (send nil? {:render :render_to_string} $...)
        PATTERN

        def_node_matcher :render_literal?, <<-PATTERN
          (send nil? {:render :render_to_string} ({str sym} $_) $...)
        PATTERN

        def_node_matcher :render_view_component?, <<-PATTERN
          (send nil? {:render :render_to_string} (send _ :new ...) ...)
        PATTERN

        def_node_matcher :render_view_component_collection?, <<-PATTERN
          (send nil? {:render :render_to_string} (send _ :with_collection ...) ...)
        PATTERN

        def_node_matcher :render_with_options?, <<-PATTERN
          (send nil? {:render :render_to_string} (hash $...) ...)
        PATTERN

        def_node_matcher :ignore_key?, <<-PATTERN
          (pair (sym {
            :inline
          }) $_)
        PATTERN

        def_node_matcher :locals_key?, <<-PATTERN
          (pair (sym {
            :locals
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

        def hash_with_literal_keys?(hash)
          hash.pairs.all? { |pair| literal?(pair.key) }
        end

        def on_send(node)
          return unless render?(node)

          # Ignore "component"-style renders
          return if render_view_component?(node) || render_view_component_collection?(node)

          if render_literal?(node)
          elsif option_pairs = render_with_options?(node)
            if option_pairs.any? { |pair| ignore_key?(pair) }
              return
            end

            if partial_node = option_pairs.map { |pair| partial_key?(pair) }.compact.first
              if !literal?(partial_node)
                add_offense(node, location: :expression)
                return
              end
            else
              add_offense(node, location: :expression)
              return
            end
          else
            add_offense(node, location: :expression)
            return
          end

          if render_literal?(node) && node.arguments.count > 1
            locals = node.arguments[1]
          elsif options_pairs = render_with_options?(node)
            locals = option_pairs.map { |pair| locals_key?(pair) }.compact.first
          end

          if locals
            if locals.hash_type?
              if !hash_with_literal_keys?(locals)
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
end

# frozen_string_literal: true

require "rubocop"
require "rubocop/cop/github/render_literal_helpers"

module RuboCop
  module Cop
    module GitHub
      class RailsControllerRenderLiteral < Cop
        include RenderLiteralHelpers

        MSG = "render must be used with a string literal or an instance of a Class"

        def_node_matcher :ignore_key?, <<-PATTERN
          (pair (sym {
            :body
            :file
            :html
            :inline
            :js
            :json
            :nothing
            :plain
            :text
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

        def_node_matcher :options_key?, <<-PATTERN
          (pair (sym {
            :content_type
            :location
            :status
            :formats
          }) ...)
        PATTERN

        def_node_matcher :render_const?, <<-PATTERN
          (send nil? {:render :render_to_string} (const _ _) ...)
        PATTERN

        def on_send(node)
          return unless render?(node)

          if render_literal?(node) || render_view_component?(node) || render_const?(node)
          elsif option_pairs = render_with_options?(node)
            option_pairs = option_pairs.reject { |pair| options_key?(pair) }

            if option_pairs.any? { |pair| ignore_key?(pair) }
              return
            end

            if template_node = option_pairs.map { |pair| template_key?(pair) }.compact.first
              if !literal?(template_node)
                add_offense(node, location: :expression)
              end
            else
              add_offense(node, location: :expression)
            end

            if layout_node = option_pairs.map { |pair| layout_key?(pair) }.compact.first
              if !literal?(layout_node)
                add_offense(node, location: :expression)
              end
            end
          else
            add_offense(node, location: :expression)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsControllerRenderShorthand < Cop
        MSG = "Prefer `render` template shorthand"

        def_node_matcher :render_with_options?, <<-PATTERN
          (send nil? :render (hash $...))
        PATTERN

        def_node_matcher :action_key?, <<-PATTERN
          (pair (sym {:action :template}) $({str sym} _))
        PATTERN

        def_node_matcher :str, <<-PATTERN
          ({str sym} $_)
        PATTERN

        def investigate(*)
          @autocorrect = {}
        end

        def autocorrect(node)
          @autocorrect[node]
        end

        def on_send(node)
          if option_pairs = render_with_options?(node)
            option_pairs.each do |pair|
              if value_node = action_key?(pair)
                comma = option_pairs.length > 1 ? ", " : ""
                corrected_source = node.source
                  .sub(/#{pair.source}(,\s*)?/, "")
                  .sub("render ", "render \"#{str(value_node)}\"#{comma}")

                @autocorrect[node] = lambda do |corrector|
                  corrector.replace(node.source_range, corrected_source)
                end
                add_offense(node, location: :expression, message: "Use `#{corrected_source}` instead")
              end
            end
          end
        end
      end
    end
  end
end

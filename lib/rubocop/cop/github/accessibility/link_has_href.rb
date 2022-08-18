# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      module Accessibility
        class LinkHasHref < Base
          MSG = "Links should go somewhere, you probably want to use a `<button>` instead.".freeze

          def on_send(node)
            if node.receiver.nil? && node.method?(:link_to)
              args = node.arguments
              if args.length == 1 || (args.length > 1 && args[1].str_type? && args[1].children.first == "#")
                add_offense(node.loc.selector)
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      module Accessibility
        class LinkHasHref < Base
          MSG = "Links should go somewhere, you probably want to use a `<button>` instead."

          def on_send(node)
            receiver, method_name, *args = *node

            if receiver.nil? && method_name == :link_to
              add_offense(node.loc.selector) if args.length == 1 || (args.length > 1 && args[1].type == :str && args[1].children.first == "#")
            end
          end
        end
      end
    end
  end
end

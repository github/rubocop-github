# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      module Accessibility
        class ImageHasAlt < Base
          MSG = "Images should have an alt prop with meaningful text or an empty string for decorative images"

          # @!method has_alt_attribute?(node)
          def_node_search :has_alt_attribute?, "(sym :alt)"

          def on_send(node)
            receiver, method_name, _= *node

            if receiver.nil? && method_name == :image_tag
              alt = has_alt_attribute?(node)
              add_offense(node.loc.selector) if alt.nil?
            end
          end
        end
      end
    end
  end
end

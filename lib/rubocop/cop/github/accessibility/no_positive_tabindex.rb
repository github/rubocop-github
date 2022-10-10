# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      module Accessibility
        class NoPositiveTabindex < Base
          MSG = "Positive tabindex is error-prone and often inaccessible."

          def on_send(node)
            receiver, method_name, *args = *node
            if receiver.nil?
              args.select do |arg|
                arg.type == :hash
              end.each do |hash|
                hash.each_pair do |key, value|
                  next if key.type == :dsym
                  next unless key.respond_to?(:value)
                  add_offense(hash) if key.value == :tabindex && value.source.to_i > 0
                end
              end
            end
          end
        end
      end
    end
  end
end

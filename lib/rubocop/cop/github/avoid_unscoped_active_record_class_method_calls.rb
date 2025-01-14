# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      # Public: A Rubocop to discourage unscoped calls to potentially dangerous ActiveRecord class methods.
      #
      # Examples:
      #
      #     # bad
      #     class Widget < ActiveRecord::Base
      #       def self.do_class_business
      #         widget_count = ids.size
      #       end
      #     end
      #
      #     # good
      #     class Widget < ActiveRecord::Base
      #       def self.do_class_business(user)
      #         user_widget_count = where(user: user).ids.size
      #       end
      #     end
      class AvoidUnscopedActiveRecordClassMethodCalls < Base
        MESSAGE_TEMPLATE = "Avoid using ActiveModel.%s without a scope."
        DANGEROUS_METHODS = %i(ids).freeze

        def_node_matcher :active_record?, <<~PATTERN
          {
            (const {nil? cbase} :ApplicationRecord)
            (const (const {nil? cbase} :ActiveRecord) :Base)
          }
        PATTERN

        def on_send(node)
          return unless dangerous_method?(node)
          return unless nil_receiver?(node)
          return unless used_in_class_method?(node)
          return unless class_is_active_record?(node)

          add_offense(node, message: MESSAGE_TEMPLATE % node.method_name)
        end

        private

        def dangerous_method?(node)
          DANGEROUS_METHODS.include?(node.method_name)
        end

        def nil_receiver?(node)
          node.receiver.nil?
        end

        def used_in_class_method?(node)
          return false if node.nil?
          return true if node.defs_type?
          return false if node.def_type?
          used_in_class_method?(node.parent)
        end

        def class_is_active_record?(node)
          node.each_ancestor(:class).any? { |class_node| active_record?(class_node.parent_class) }
        end
      end
    end
  end
end

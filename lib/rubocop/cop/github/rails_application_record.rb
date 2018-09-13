# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      # Using an `ApplicationRecord` base class gives you a place to extend and modify
      # behaviors from `ActiveRecord::Base`, which can make it easier to manage
      # application-wide changes or isolate undesirable behavior from the framework.
      #
      # @example
      #
      #   # good
      #   class ApplicationRecord < ActiveRecord::Base; end
      #   class Post < ApplicationRecord; end
      #   class Comment < ApplicationRecord; end
      #
      #   # bad
      #   class Post < ActiveRecord::Base; end
      #   class Comment < ActiveRecord::Base; end
      #
      class RailsApplicationRecord < Cop
        MSG = "Models should subclass from ApplicationRecord"

        def_node_matcher :active_record_base_const?, <<-PATTERN
          (const (const nil? :ActiveRecord) :Base)
        PATTERN

        def_node_matcher :application_record_const?, <<-PATTERN
          (const nil? :ApplicationRecord)
        PATTERN

        def on_class(node)
          klass, superclass, _ = *node

          if active_record_base_const?(superclass) && !(application_record_const?(klass))
            add_offense(superclass, location: :expression)
          end
        end

        def autocorrect(superclass_node)
          lambda do |corrector|
            corrector.replace(superclass_node.source_range, "ApplicationRecord")
          end
        end
      end
    end
  end
end

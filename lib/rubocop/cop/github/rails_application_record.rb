require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class RailsApplicationRecord < Cop
        MSG = "Models should subclass from ApplicationRecord"

        ACTIVE_RECORD_BASE = s(:const, s(:const, nil, :ActiveRecord), :Base)

        def on_class(node)
          _name, superclass, _body = *node

          if superclass == ACTIVE_RECORD_BASE
            add_offense(superclass, :expression)
          end
        end
      end
    end
  end
end

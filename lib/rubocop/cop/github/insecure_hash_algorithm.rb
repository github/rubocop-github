# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class InsecureHashAlgorithm < Cop
        MSG = "This hash algorithm is old and insecure, use SHA-256 instead"

        def_node_matcher :insecure_const?, <<-PATTERN
          (const (const _ :Digest) #insecure_algorithm?)
        PATTERN

        def_node_matcher :insecure_call?, <<-PATTERN
          (send (const _ {:Digest :HMAC}) _ (str #insecure_algorithm?) ...)
        PATTERN

        def insecure_algorithm?(val)
          case val.to_s.downcase
          when "md5", "sha1"
            true
          else
            false
          end
        end

        def on_const(const_node)
          if insecure_const?(const_node)
            add_offense(const_node, message: MSG)
          end
        end

        def on_send(send_node)
          if insecure_call?(send_node)
            add_offense(send_node, message: MSG)
          end
        end
      end
    end
  end
end

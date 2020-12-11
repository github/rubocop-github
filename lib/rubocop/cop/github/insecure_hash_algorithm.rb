# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class InsecureHashAlgorithm < Cop
        MSG = "This hash algorithm is old and insecure, use SHA-256 instead"

        # Matches constants like these:
        #   Digest::MD5
        #   OpenSSL::Digest::MD5
        def_node_matcher :insecure_const?, <<-PATTERN
          (const (const _ :Digest) #insecure_algorithm?)
        PATTERN

        # Matches calls like these:
        #   Digest.new('md5')
        #   Digest.hexdigest('md5', 'str')
        #   OpenSSL::Digest.new('md5')
        #   OpenSSL::Digest.hexdigest('md5', 'str')
        #   OpenSSL::Digest::Digest.new('md5')
        #   OpenSSL::Digest::Digest.hexdigest('md5', 'str')
        #   OpenSSL::Digest::Digest.new(:MD5)
        #   OpenSSL::Digest::Digest.hexdigest(:MD5, 'str')
        def_node_matcher :insecure_digest?, <<-PATTERN
          (send
            (const _ {:Digest :HMAC})
            #not_just_encoding?
            #insecure_algorithm?
            ...)
        PATTERN

        # Matches calls like "Digest(:MD5)".
        def_node_matcher :insecure_hash_lookup?, <<-PATTERN
          (send _ :Digest #insecure_algorithm?)
        PATTERN

        def insecure_algorithm?(val)
          return false if val == :Digest # Don't match "Digest::Digest".
          case str_val(val).downcase
          when "ripemd160", "rmd160", "sha224", "sha256", "sha384", "sha512"
            false
          else
            true
          end
        end

        def not_just_encoding?(val)
          !just_encoding?(val)
        end

        def just_encoding?(val)
          val == :hexencode || val == :bubblebabble
        end

        def str_val(val)
          return "" if val.nil?
          return val.to_s unless val.is_a?(RuboCop::AST::Node)
          return val.children.first.to_s if val.type == :sym || val.type == :str
          raise "Unexpected: #{val.inspect}"
        end

        def on_const(const_node)
          if insecure_const?(const_node)
            add_offense(const_node, message: MSG)
          end
        end

        def on_send(send_node)
          case
          when insecure_digest?(send_node)
            add_offense(send_node, message: MSG)
          when insecure_hash_lookup?(send_node)
            add_offense(send_node, message: MSG)
          end
        end
      end
    end
  end
end

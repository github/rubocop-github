# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module GitHub
      class InsecureHashAlgorithm < Cop
        MSG = "This hash function is not allowed"

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

        # Matches calls like "OpenSSL::HMAC.new(secret, hash)"
        def_node_matcher :openssl_hmac_new?, <<-PATTERN
          (send (const (const _ :OpenSSL) :HMAC) :new ...)
        PATTERN

        # Matches calls like "OpenSSL::HMAC.new(secret, 'sha1')"
        def_node_matcher :openssl_hmac_new_insecure?, <<-PATTERN
          (send (const (const _ :OpenSSL) :HMAC) :new _ #insecure_algorithm?)
        PATTERN

        def insecure_algorithm?(val)
          return false if val == :Digest # Don't match "Digest::Digest".
          case alg_name(val)
          when *allowed_hash_functions
            false
          when Symbol
            # can't figure this one out, it's nil or a var or const.
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

        # Built-in hash functions are listed in these docs:
        #  https://ruby-doc.org/stdlib-2.7.0/libdoc/digest/rdoc/Digest.html
        #  https://ruby-doc.org/stdlib-2.7.0/libdoc/openssl/rdoc/OpenSSL/Digest.html
        DEFAULT_ALLOWED = %w[
          SHA256
          SHA384
          SHA512
        ].freeze

        def allowed_hash_functions
          @allowed_algorithms ||= cop_config.fetch("Allowed", DEFAULT_ALLOWED).map(&:downcase)
        end

        def alg_name(val)
          return :nil if val.nil?
          return val.to_s.downcase unless val.is_a?(RuboCop::AST::Node)
          case val.type
          when :sym, :str
            val.children.first.to_s.downcase
          else
            val.type
          end
        end

        def on_const(const_node)
          if insecure_const?(const_node)
            add_offense(const_node, message: MSG)
          end
        end

        def on_send(send_node)
          case
          when openssl_hmac_new?(send_node)
            if openssl_hmac_new_insecure?(send_node)
              add_offense(send_node, message: MSG)
            end
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

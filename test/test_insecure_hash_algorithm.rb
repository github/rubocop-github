# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/insecure_hash_algorithm"

class TestInsecureHashAlgorithm < CopTest
  def cop_class
    RuboCop::Cop::GitHub::InsecureHashAlgorithm
  end

  def test_kitchen_sink
    investigate(cop, <<-RUBY)
      class Something
        BAD_ALGO = Digest::MD5
                   #^^^^^^^^^^^ #{message}
        GOOD_ALGO = Digest::SHA256
        OBAD_ALGO = OpenSSL::Digest::MD5
                    #^^^^^^^^^^^^^^^^^^^^ #{message}
        BAD_SHA1_ALGO = Digest::SHA1
                        #^^^^^^^^^^^^ #{message}
        OBAD_SHA1_ALGO = OpenSSL::Digest::SHA1
                         #^^^^^^^^^^^^^^^^^^^^^ #{message}

        def kitchen_sink_hash(str)
          BAD_ALGO.hexdigest(str) +
            GOOD_ALGO.hexdigest(str) +
            Digest::MD5.hexdigest(str) +
            #^^^^^^^^^^^ #{message}
            Digest::SHA1.hexdigest(str) +
            #^^^^^^^^^^^^ #{message}
            OpenSSL::Digest::MD5.hexdigest(str) +
            #^^^^^^^^^^^^^^^^^^^^ #{message}
            OpenSSL::Digest::SHA1.hexdigest(str)
            #^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::Digest.digest("MD5", str)
          #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::Digest.digest("SHA1", str)
          #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::Digest.hexdigest("Sha1", str)
          #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::Digest.digest("SHA256", str)
          OpenSSL::HMAC.hexdigest('md5', str)
          #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::HMAC.hexdigest('sha1', str)
          #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::HMAC.hexdigest('sha256', str)
          OpenSSL::Digest::Digest.new('md5')
          #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::Digest::Digest.new('sha1')
          #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
          OpenSSL::Digest::Digest.new('sha256')
        end
      end
    RUBY

    assert_equal 15, cop.offenses.count
    assert_equal([cop_class::MESSAGE], cop.offenses.map(&:message).uniq)
  end
end

# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/insecure_hash_algorithm"

class TestInsecureHashAlgorithm < CopTest
  def cop_class
    RuboCop::Cop::GitHub::InsecureHashAlgorithm
  end

  def make_cop(allowed:)
    config = RuboCop::Config.new({"GitHub/InsecureHashAlgorithm" => {"Allowed" => allowed}})
    cop_class.new(config)
  end

  def test_benign_apis
    investigate(cop, <<-RUBY)
      class Something
        def hexencode_the_string_md5
          Digest.hexencode('anything')
        end
        def bubblebabble_the_string_md5
          Digest.bubblebabble('anything')
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_openssl_hmac_new_sha256_indirect
    investigate(cop, <<-RUBY)
      class Something
        HASH = OpenSSL::Digest::SHA256

        attr :secret

        def secret_hmac
          OpenSSL::HMAC.new(self.secret, HASH)
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_openssl_hmac_new_sha1
    investigate(cop, <<-RUBY)
      class Something
        attr :secret

        def secret_hmac
          OpenSSL::HMAC.new(self.secret, 'sha1')
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_digest_method_md5_str
    investigate(cop, <<-RUBY)
      class Something
        def h
          Digest('md5')
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_digest_method_md5_symbol
    investigate(cop, <<-RUBY)
      class Something
        def h
          Digest(:MD5)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_digest_method_sha256_str
    investigate(cop, <<-RUBY)
      class Something
        def h
          Digest('sha256')
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_digest_method_sha256_symbol
    investigate(cop, <<-RUBY)
      class Something
        def h
          Digest('sha256')
        end

        def h
          Digest(:SHA256)
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_alias_for_digest_md5
    investigate(cop, <<-RUBY)
      class Something
        HASH = Digest::MD5
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_alias_for_openssl_digest_md5
    investigate(cop, <<-RUBY)
      class Something
        HASH = OpenSSL::Digest::MD5
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_alias_for_digest_sha1
    investigate(cop, <<-RUBY)
      class Something
        HASH = Digest::SHA1
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_alias_for_openssl_digest_sha1
    investigate(cop, <<-RUBY)
      class Something
        HASH = OpenSSL::Digest::SHA1
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_alias_for_digest_sha256
    investigate(cop, <<-RUBY)
      class Something
        HASH = Digest::SHA256
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_alias_for_openssl_digest_sha256
    investigate(cop, <<-RUBY)
      class Something
        HASH = OpenSSL::Digest::SHA256
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_hexdigest_on_random_class
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          HASH.hexdigest(str)
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_md5_hexdigest
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          Digest::MD5.hexdigest(str)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_md5_hexdigest
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest::MD5.hexdigest(str)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_md5_digest_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest.digest("MD5", str)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_sha1_digest_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest.digest("SHA1", str)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_sha1_hexdigest_by_name_mixed_case
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest.hexdigest("Sha1", str)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_sha256_digest_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest.digest("SHA256", str)
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_openssl_md5_hmac_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::HMAC.hexdigest('md5', str)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_sha1_hmac_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::HMAC.hexdigest('sha1', str)
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_sha256_hmac_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::HMAC.hexdigest('sha256', str)
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_openssl_md5_digest_instance_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest::Digest.new('md5')
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_sha1_digest_instance_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest::Digest.new('sha1')
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MSG, cop.offenses.first.message
  end

  def test_openssl_sha256_digest_instance_by_name
    investigate(cop, <<-RUBY)
      class Something
        def something(str)
          OpenSSL::Digest::Digest.new('sha256')
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_uuid_from_hash
    investigate(cop, <<-RUBY)
      class Something
        def uuid
          # I want to demonstrate that uuid_from_hash isn't a trigger,
          # even though I don't know if it's even valid to use SHA256.
          Digest::UUID.uuid_from_hash(Digest::SHA256, 'abc', 'def')
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_uuid_v3
    investigate(cop, <<-RUBY)
      class Something
        def uuid
          Digest::UUID.uuid_v3('anything', 'anything')
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::UUID_V3_MSG, cop.offenses.first.message
  end

  def test_uuid_v3_with_md5_allowed
    cop = make_cop(allowed: %w[MD5])
    investigate(cop, <<-RUBY)
      class Something
        def uuid
          Digest::UUID.uuid_v3('anything', 'anything')
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_uuid_v4
    investigate(cop, <<-RUBY)
      class Something
        def uuid
          Digest::UUID.uuid_v4
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_uuid_v5
    investigate(cop, <<-RUBY)
      class Something
        def uuid
          Digest::UUID.uuid_v5('anything', 'anything')
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::UUID_V5_MSG, cop.offenses.first.message
  end

  def test_uuid_v5_with_sha1_allowed
    cop = make_cop(allowed: %w[SHA1])
    investigate(cop, <<-RUBY)
      class Something
        def uuid
          Digest::UUID.uuid_v5('anything', 'anything')
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_allow_sha512_only
    cop = make_cop(allowed: %w[SHA512])
    investigate(cop, <<-RUBY)
      class Something
        HASH = Digest::SHA256
      end
    RUBY
    assert_equal 1, cop.offenses.count
  end

  def test_allow_lots_of_hashes
    cop = make_cop(allowed: %w[SHA1 SHA256 SHA384 SHA512])
    investigate(cop, <<-RUBY)
      class Something
        HASH = Digest::SHA1
      end
    RUBY
    assert_equal 0, cop.offenses.count
  end
end

# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/insecure_hash_algorithm"

class TestInsecureHashAlgorithm < CopTest
  def cop_class
    RuboCop::Cop::GitHub::InsecureHashAlgorithm
  end

  def test_alias_for_digest_md5
    investigate(cop, <<-RUBY)
      class Something
        HASH = Digest::MD5
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
  end

  def test_alias_for_openssl_digest_md5
    investigate(cop, <<-RUBY)
      class Something
        HASH = OpenSSL::Digest::MD5
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
  end

  def test_alias_for_digest_sha1
    investigate(cop, <<-RUBY)
      class Something
        HASH = Digest::SHA1
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
  end

  def test_alias_for_openssl_digest_sha1
    investigate(cop, <<-RUBY)
      class Something
        HASH = OpenSSL::Digest::SHA1
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
    assert_equal cop_class::MESSAGE, cop.offenses.first.message
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
end

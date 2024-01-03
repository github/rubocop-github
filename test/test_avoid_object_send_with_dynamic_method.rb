# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/avoid_object_send_with_dynamic_method"

class TestAvoidObjectSendWithDynamicMethod < CopTest
  def cop_class
    RuboCop::Cop::GitHub::AvoidObjectSendWithDynamicMethod
  end

  def test_offended_by_send_call
    offenses = investigate cop, <<-RUBY
      def my_method(foo)
        foo.send(@some_ivar)
      end
    RUBY
    assert_equal 1, offenses.size
    assert_equal "Avoid using Object#send with a dynamic method name.", offenses.first.message
  end

  def test_offended_by_public_send_call
    offenses = investigate cop, <<-RUBY
      foo.public_send(bar)
    RUBY
    assert_equal 1, offenses.size
    assert_equal "Avoid using Object#public_send with a dynamic method name.", offenses.first.message
  end

  def test_offended_by_call_to___send__
    offenses = investigate cop, <<-RUBY
      foo.__send__(bar)
    RUBY
    assert_equal 1, offenses.size
    assert_equal "Avoid using Object#__send__ with a dynamic method name.", offenses.first.message
  end

  def test_offended_by_send_calls_without_receiver
    offenses = investigate cop, <<-RUBY
      send(some_method)
      public_send(@some_ivar)
      __send__(a_variable, "foo", "bar")
    RUBY
    assert_equal 3, offenses.size
    assert_equal "Avoid using Object#send with a dynamic method name.", offenses[0].message
    assert_equal "Avoid using Object#public_send with a dynamic method name.", offenses[1].message
    assert_equal "Avoid using Object#__send__ with a dynamic method name.", offenses[2].message
  end

  def test_unoffended_by_other_method_calls
    offenses = investigate cop, <<-RUBY
      foo.bar(arg1, arg2)
      case @some_ivar
      when :foo
        baz.foo
      when :bar
        baz.bar
      end
      puts "public_send" if send?
    RUBY
    assert_equal 0, offenses.size
  end

  def test_unoffended_by_send_calls_to_dynamic_methods_that_include_hardcoded_strings
    offenses = investigate cop, <<-'RUBY'
      foo.send("can_#{action}?")
      foo.public_send("make_#{SOME_CONSTANT}")
    RUBY
    assert_equal 0, offenses.size
  end

  def test_unoffended_by_send_calls_without_dynamic_methods
    offenses = investigate cop, <<-RUBY
      base.send :extend, ClassMethods
      foo.public_send(:bar)
      foo.__send__("bar", arg1, arg2)
    RUBY
    assert_equal 0, offenses.size
  end
end

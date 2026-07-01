# frozen_string_literal: true

require_relative "cop_test"
require "minitest/autorun"
require "rubocop/cop/github/unreliable_subclasses"

class TestUnreliableSubclasses < CopTest
  def cop_class
    RuboCop::Cop::GitHub::UnreliableSubclasses
  end

  def test_offended_by_descendants_call
    offenses = investigate cop, <<~RUBY
      ApplicationRecord.descendants
    RUBY
    assert_equal 1, offenses.size
    assert_match(/Avoid `descendants`/, offenses.first.message)
  end

  def test_offended_by_subclasses_call
    offenses = investigate cop, <<~RUBY
      ApplicationRecord.subclasses
    RUBY
    assert_equal 1, offenses.size
    assert_match(/Avoid `subclasses`/, offenses.first.message)
  end

  def test_offended_on_namespaced_constant
    offenses = investigate cop, <<~RUBY
      Foo::Bar::Baz.descendants
    RUBY
    assert_equal 1, offenses.size
  end

  def test_offended_on_self_receiver
    # self.subclasses in a class method body is still Class#subclasses
    offenses = investigate cop, <<~RUBY
      class ApplicationRecord
        def self.known_subclasses
          self.subclasses
        end
      end
    RUBY
    assert_equal 1, offenses.size
  end

  def test_offended_when_chained
    offenses = investigate cop, <<~RUBY
      Tea.descendants.map(&:name)
      Tea.subclasses.each { |k| k.foo }
      Tea.descendants.size
      Tea.subclasses.count
    RUBY
    assert_equal 4, offenses.size
  end

  def test_offended_by_safe_navigation_on_constant
    offenses = investigate cop, <<~RUBY
      Tea&.descendants
      Tea&.subclasses
    RUBY
    assert_equal 2, offenses.size
  end

  def test_unoffended_by_non_constant_receiver
    offenses = investigate cop, <<~RUBY
      comment.descendants
      category.subclasses
      tree_node&.descendants
      registry[:foo].subclasses
    RUBY
    assert_equal 0, offenses.size
  end

  def test_unoffended_when_called_with_arguments
    # arity mismatch
    offenses = investigate cop, <<~RUBY
      Registry.subclasses(:include_abstract)
      Tree.descendants(depth: 2)
    RUBY
    assert_equal 0, offenses.size
  end

  def test_unoffended_by_unrelated_methods
    offenses = investigate cop, <<~RUBY
      Tea.all
      Tea.where(roasted: true)
      ApplicationRecord.connection
    RUBY
    assert_equal 0, offenses.size
  end
end

# frozen_string_literal: true

require_relative "cop_test"
require "minitest/autorun"
require "rubocop/cop/github/avoid_unscoped_active_record_class_method_calls"

class TestAvoidUnscopedActiveRecordClassMethodCalls < CopTest
  def cop_class
    RuboCop::Cop::GitHub::AvoidUnscopedActiveRecordClassMethodCalls
  end

  def test_offended_by_unscoped_call_from_active_record_class_method
    offenses = investigate cop, <<-RUBY
      class Widget < ApplicationRecord
        def self.do_class_business
          count = ids.size
        end
      end
    RUBY

    assert_equal 1, offenses.size
    assert_equal "#{cop.name}: Avoid using ActiveModel.ids without a scope.", offenses.first.message
  end

  def test_unoffended_by_unscoped_call_from_non_active_record_class_method
    offenses = investigate cop, <<-RUBY
      class Widget < OtherClass
        def self.do_class_business
          count = ids.size
        end
      end
    RUBY

    assert_equal 0, offenses.size
  end

  def test_unoffended_by_unscoped_call_from_active_record_instance_method
    offenses = investigate cop, <<-RUBY
      class Widget < ApplicationRecord::Thing
        def do_instance_business
          count = ids.size
        end
      end
    RUBY

    assert_equal 0, offenses.size
  end
end

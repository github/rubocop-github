# frozen_string_literal: true

require_relative './cop_test'
require 'minitest/autorun'
require 'rubocop/cop/standard/rails_application_record'

class TestRailsApplicationRecord < CopTest
  def cop_class
    RuboCop::Cop::Standard::RailsApplicationRecord
  end

  def test_good_model
    investigate(cop, <<-RUBY)
      class Repository < ApplicationRecord
      end
    RUBY

    assert_empty cop.offenses.map(&:message)
  end

  def test_application_record_model
    investigate(cop, <<-RUBY)
      class ApplicationRecord < ActiveRecord::Base
      end
    RUBY

    assert_empty cop.offenses.map(&:message)
  end

  def test_bad_model
    investigate(cop, <<-RUBY)
      class Repository < ActiveRecord::Base
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'Models should subclass from ApplicationRecord', cop.offenses.first.message
  end
end

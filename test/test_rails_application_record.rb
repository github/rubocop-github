# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_application_record"

class TestRailsApplicationRecord < CopTest
  def cop_class
    RuboCop::Cop::GitHub::RailsApplicationRecord
  end

  def test_good_model
    offenses = investigate(cop, <<-RUBY)
      class Repository < ApplicationRecord
      end
    RUBY

    assert_empty offenses.map(&:message)
  end

  def test_application_record_model
    offenses = investigate(cop, <<-RUBY)
      class ApplicationRecord < ActiveRecord::Base
      end
    RUBY

    assert_empty offenses.map(&:message)
  end

  def test_bad_model
    offenses = investigate(cop, <<-RUBY)
      class Repository < ActiveRecord::Base
      end
    RUBY

    assert_equal 1, offenses.count
    assert_equal "Models should subclass from ApplicationRecord", offenses.first.message
  end
end

# frozen_string_literal: true

require "rubocop/cop/github/rails_application_record"
require "minitest/autorun"

class TestRailsApplicationRecord < MiniTest::Test
  def setup
    config = RuboCop::Config.new
    @cop = RuboCop::Cop::GitHub::RailsApplicationRecord.new(config)
  end

  def test_good_model
    investigate(@cop, <<-RUBY)
      class Repository < ApplicationRecord
      end
    RUBY

    assert_empty @cop.offenses.map(&:message)
  end

  def test_application_record_model
    investigate(@cop, <<-RUBY)
      class ApplicationRecord < ActiveRecord::Base
      end
    RUBY

    assert_empty @cop.offenses.map(&:message)
  end

  def test_bad_model
    investigate(@cop, <<-RUBY)
      class Repository < ActiveRecord::Base
      end
    RUBY

    assert_equal 1, @cop.offenses.count
    assert_equal "Models should subclass from ApplicationRecord", @cop.offenses.first.message
  end

  private

  def investigate(cop, src)
    processed_source = RuboCop::ProcessedSource.new(src, RUBY_VERSION.to_f)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
    commissioner.investigate(processed_source)
    commissioner
  end
end
